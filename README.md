# REEV Docker Compose Configuration

This repository contains the [Docker Compose](https://docs.docker.com/compose/) configuration for [REEV](https://github.com/bihealth/reev).

## Development Setup

This section describes the steps needed for a development setup.

### Prerequites

You will need to fetch some of this from our S3 server.
We recommend the `s5cmd` tool as it is easy to install, use, and fast.
You can download it from [github.com/peak/s5cmd/releases](https://github.com/peak/s5cmd/releases).
For example:

```bash session
wget -O /tmp/s5cmd_2.1.0_Linux-64bit.tar.gz \
    https://github.com/peak/s5cmd/releases/download/v2.1.0/s5cmd_2.1.0_Linux-64bit.tar.gz
tar -C /tmp -xf /tmp/s5cmd_2.1.0_Linux-64bit.tar.gz
sudo cp /tmp/s5cmd /usr/local/bin/
```

You will need to install Docker Compose.
Note that the "modern" way is to do this by using the docker compose plugin.
Instructions can be found [here on the Docker.com website](https://docs.docker.com/compose/install/linux/#install-using-the-repository).

### Checkout and Configure

First, clone the repository:

```bash session
git clone git@github.com:bihealth/reev-docker-compose.git
```

From here on, the commands should be executed from within this repository (`cd reev-docker-compose`).

We will use the directory `.dev` within the checkout for storing data and secrets.
In a production deployment, these directories should live outside of the checkout, of course.

Now, we create the directories for data storage.

```bash session
mkdir -p .dev/volumes/pgadmin/data
mkdir -p .dev/volumes/postgres/data
mkdir -p .dev/volumes/rabbitmq/data
mkdir -p .dev/volumes/redis/data
mkdir -p .dev/volumes/reev-static/data
```

Next, we setup some "secrets" for the passwords.

```bash session
mkdir -p .dev/secrets
echo db-password >.dev/secrets/db-password
echo pgadmin-password >.dev/secrets/pgadmin-password
```

We now copy the `env.tpl` file to the default location for the environment `.env`.

```bash session
cp env.tpl .env
```

Next, create a `docker-compose.override.yml` with the contents of the file `docker-compose.override.yml-dev`.
This will disable everything that we assume is running on your host when you are developing.
This includes the REEV backend, rabbitmq, celery workers, postgres.

```bash session
cp docker-compose.override.yml-dev docker-compose.override.yml
```

### Download Dev Data

Now you need to obtain the data to serve by the mehari, viguno, and annonars container.
For this, we have prepared strongly reduced data sets (overall less than 2GB rather than hundreds of GB of data).
Obtain the annonars data:

```bash session
mkdir -p .dev/volumes/reev-static/data/download
SRC_DST="
full/annonars/gnomad-mtdna-grch37-3.1+0.12.8/*:annonars/gnomad-mtdna-grch37-3.1+0.12.8
full/annonars/gnomad-mtdna-grch38-3.1+0.12.8/*:annonars/gnomad-mtdna-grch38-3.1+0.12.8
full/annonars/helixmtdb-grch37-20200327+0.12.8/*:annonars/helixmtdb-grch37-20200327+0.12.8
full/annonars/helixmtdb-grch38-20200327+0.12.8/*:annonars/helixmtdb-grch38-20200327+0.12.8
full/annonars/genes-3.1+2.1.1+4.4+20230606+10.1+20230828+0.19.0/*:annonars/genes-3.1+2.1.1+4.4+20230606+10.1+20230828+0.19.0
full/mehari/genes-txs-grch37-0.2.2/*:mehari/genes-txs-grch37-0.2.2
full/mehari/genes-txs-grch38-0.2.2/*:mehari/genes-txs-grch38-0.2.2
full/mehari/genes-xlink-20230624/*:mehari/genes-xlink-20230624
full/tracks/*:tracks
full/worker/*:worker
reduced-dev/annonars/*:annonars
reduced-dev/mehari/*:mehari
reduced-dev/viguno/*:viguno
"
(set -x; for src_dst in $SRC_DST; do \
  src=$(echo $src_dst | cut -d : -f 1); \
  dst=$(echo $src_dst | cut -d : -f 2); \
  mkdir -p .dev/volumes/reev-static/data/download/$dst; \
  s5cmd \
    --endpoint-url=https://ceph-s3-public.cubi.bihealth.org \
    --no-sign-request \
    sync \
      "s3://varfish-public/$src" \
      ".dev/volumes/reev-static/data/download/$dst"; \
done)
```

Setup symlink structure so the data is at the expected location.

```bash session
##
## annonars
##

mkdir -p .dev/volumes/reev-static/data/annonars

ln -sr .dev/volumes/reev-static/data/download/annonars/genes-* \
  .dev/volumes/reev-static/data/annonars/genes

names="cadd dbsnp dbnsfp dbscsnv gnomad-mtdna gnomad-genomes gnomad-exomes helixmtdb cons"; \
for genome in grch37 grch38; do \
  for name in $names; do \
    mkdir -p .dev/volumes/reev-static/data/annonars/$genome; \
    test -e .dev/volumes/reev-static/data/$genome/$name || \
      ln -sr \
        $(echo .dev/volumes/reev-static/data/download/annonars/$name-$genome-* \
          | tr ' ' '\n' \
          | tail -n 1) \
        .dev/volumes/reev-static/data/annonars/$genome/$name; \
  done; \
done

##
## mehari
##

mkdir -p .dev/volumes/reev-static/data/mehari/grch3{7,8}

ln -sr .dev/volumes/reev-static/data/download/mehari/genes-txs-grch37-*/mehari-data-txs-grch37-*in.zst \
  .dev/volumes/reev-static/data/mehari/grch37/txs.bin.zst
ln -sr .dev/volumes/reev-static/data/download/mehari/freqs-grch37-* \
  .dev/volumes/reev-static/data/mehari/grch37/freqs
ln -sr .dev/volumes/reev-static/data/download/mehari/genes-txs-grch38-*/mehari-data-txs-grch38-*.bin.zst \
  .dev/volumes/reev-static/data/mehari/grch38/txs.bin.zst
ln -sr .dev/volumes/reev-static/data/download/mehari/freqs-grch38-* \
  .dev/volumes/reev-static/data/mehari/grch38/freqs

##
## viguno
##

ln -sr .dev/volumes/reev-static/data/download/mehari/genes-xlink-20230624/genes-xlink.tsv \
  .dev/volumes/reev-static/data/hgnc_xlink.tsv
ln -sr .dev/volumes/reev-static/data/download/viguno/hpo-20230606+0.1.6 \
  .dev/volumes/reev-static/data/hpo

##
## worker
##

mkdir -p .dev/volumes/reev-static/data/worker/{grch3{7,8}/strucvars/bgdbs,noref/genes}

ln -sr .dev/volumes/reev-static/data/download/worker/bgdb-exac-grch37-*/bgdb-exac.bin \
  .dev/volumes/reev-static/data/worker/grch37/strucvars/bgdbs/exac.bin
ln -sr .dev/volumes/reev-static/data/download/worker/bgdb-g1k-grch37-phase3v2+0.9.0/bgdb-g1k.bin \
  .dev/volumes/reev-static/data/worker/grch37/strucvars/bgdbs/g1k.bin
ln -sr .dev/volumes/reev-static/data/download/worker/bgdb-gnomad-grch37-*/bgdb-gnomad.bin \
  .dev/volumes/reev-static/data/worker/grch37/strucvars/bgdbs/gnomad.bin
ln -sr .dev/volumes/reev-static/data/download/worker/bgdb-dbvar-grch37-*/bgdb-dbvar.bin \
  .dev/volumes/reev-static/data/worker/grch37/strucvars/bgdbs/dbvar.bin
ln -sr .dev/volumes/reev-static/data/download/worker/bgdb-dbvar-grch38-*/bgdb-dbvar.bin \
  .dev/volumes/reev-static/data/worker/grch38/strucvars/bgdbs/dbvar.bin
ln -sr .dev/volumes/reev-static/data/download/worker/bgdb-dgv-grch37-*/bgdb-dgv.bin \
  .dev/volumes/reev-static/data/worker/grch37/strucvars/bgdbs/dgv.bin
ln -sr .dev/volumes/reev-static/data/download/worker/bgdb-dgv-grch38-*/bgdb-dgv.bin \
  .dev/volumes/reev-static/data/worker/grch38/strucvars/bgdbs/dgv.bin
ln -sr .dev/volumes/reev-static/data/download/worker/bgdb-dgv-gs-grch37-*/bgdb-dgv-gs.bin \
  .dev/volumes/reev-static/data/worker/grch37/strucvars/bgdbs/dgv-gs.bin
ln -sr .dev/volumes/reev-static/data/download/worker/bgdb-dgv-gs-grch38-*/bgdb-dgv-gs.bin \
  .dev/volumes/reev-static/data/worker/grch38/strucvars/bgdbs/dgv-gs.bin

ln -sr .dev/volumes/reev-static/data/download/worker/clinvar-strucvars-grch37-*/clinvar-strucvars.bin \
  .dev/volumes/reev-static/data/worker/grch37/strucvars/clinvar.bin
ln -sr .dev/volumes/reev-static/data/download/worker/clinvar-strucvars-grch38-*/clinvar-strucvars.bin \
  .dev/volumes/reev-static/data/worker/grch38/strucvars/clinvar.bin

ln -sr .dev/volumes/reev-static/data/download/worker/patho-mms-grch37-*/patho-mms.bed \
  .dev/volumes/reev-static/data/worker/grch37/strucvars/patho-mms.bin
ln -sr .dev/volumes/reev-static/data/download/worker/patho-mms-grch38-*/patho-mms.bed \
  .dev/volumes/reev-static/data/worker/grch38/strucvars/patho-mms.bin

mkdir -p .dev/volumes/reev-static/data/worker/grch3{7,8}/tads

ln -sr .dev/volumes/reev-static/data/download/worker/tads-grch37-dixon2015/hesc.bed \
  .dev/volumes/reev-static/data/worker/grch37/tads/hesc.bed
ln -sr .dev/volumes/reev-static/data/download/worker/tads-grch38-dixon2015/hesc.bed \
  .dev/volumes/reev-static/data/worker/grch38/tads/hesc.bed

ln -sr .dev/volumes/reev-static/data/download/worker/genes-xlink-*/genes-xlink.bin \
  .dev/volumes/reev-static/data/worker/noref/genes/xlink.bin
ln -sr .dev/volumes/reev-static/data/download/worker/acmg-sf-*/acmg_sf.tsv \
  .dev/volumes/reev-static/data/worker/noref/genes/acmg.tsv
ln -sr .dev/volumes/reev-static/data/download/worker/mim2gene-*/mim2gene.tsv \
  .dev/volumes/reev-static/data/worker/noref/genes/omim.tsv

mkdir -p .dev/volumes/reev-static/data/worker/grch3{7,8}/genes

ln -sr .dev/volumes/reev-static/data/download/worker/genes-regions-grch37-*/ensembl_genes.bin \
  .dev/volumes/reev-static/data/worker/grch37/genes/ensembl_regions.bin
ln -sr .dev/volumes/reev-static/data/download/worker/genes-regions-grch38-*/ensembl_genes.bin \
  .dev/volumes/reev-static/data/worker/grch38/genes/ensembl_regions.bin

ln -sr .dev/volumes/reev-static/data/download/worker/genes-regions-grch37-*/refseq_genes.bin \
  .dev/volumes/reev-static/data/worker/grch37/genes/refseq_regions.bin
ln -sr .dev/volumes/reev-static/data/download/worker/genes-regions-grch38-*/refseq_genes.bin \
  .dev/volumes/reev-static/data/worker/grch38/genes/refseq_regions.bin

mkdir -p .dev/volumes/reev-static/data/worker/grch3{7,8}/features

ln -sr .dev/volumes/reev-static/data/download/worker/masked-repeat-grch37-*/masked-repeat.bin \
  .dev/volumes/reev-static/data/worker/grch37/features/masked_repeat.bin
ln -sr .dev/volumes/reev-static/data/download/worker/masked-segdup-grch37-*/masked-segdup.bin \
  .dev/volumes/reev-static/data/worker/grch37/features/masked_seqdup.bin

ln -sr .dev/volumes/reev-static/data/download/worker/masked-repeat-grch38-*/masked-repeat.bin \
  .dev/volumes/reev-static/data/worker/grch38/features/masked_repeat.bin
ln -sr .dev/volumes/reev-static/data/download/worker/masked-segdup-grch38-*/masked-segdup.bin \
  .dev/volumes/reev-static/data/worker/grch38/features/masked_seqdup.bin

##
## tracks
##

mkdir -p .dev/volumes/reev-static/data/nginx/grch3{7,8}

paths_37=$(find .dev/volumes/reev-static/data/download/tracks/ -type f -name '*.bed' -or -name '*.bed.gz' | sort | grep grch37)
for path in $paths_37; do
  if [[ -e ${path}.tbi ]]; then
    ln -sr $path ${path}.tbi .dev/volumes/reev-static/data/nginx/grch37
  else
    ln -sr $path .dev/volumes/reev-static/data/nginx/grch37
  fi
done

paths_38=$(find .dev/volumes/reev-static/data/download/tracks/ -type f -name '*.bed' -or -name '*.bed.gz' | sort | grep grch38)
for path in $paths_38; do
  if [[ -e ${path}.tbi ]]; then
    ln -sr $path ${path}.tbi .dev/volumes/reev-static/data/nginx/grch38
  else
    ln -sr $path .dev/volumes/reev-static/data/nginx/grch38
  fi
done
```

To create an in-house database:

```bash session
reev-server-worker db mk-inhouse \
  --path-output-tsv /tmp/inhouse.tsv \
  $(find YOUR_PATH -name '*.gts.tsv.gz' | sort)

reev-server-worker db to-bin \
  --input-type strucvar-inhouse \
  --path-input /tmp/inhouse.tsv \
  --path-output-bin .dev/volumes/reev-static/data/worker/grch37/strucvars/inhouse.bin
```

To obtain ClinVar, use the following.
Note that this will install the data from November 12, 2023 and you might want to [look here for the latest release](https://github.com/bihealth/annonars-data-clinvar/releases).

```bash session
wget -O /tmp/annonars-clinvar-minimal-grch37-20231112+0.25.0.tar.gz \
  https://github.com/bihealth/annonars-data-clinvar/releases/download/annonars-data-clinvar-20231112/annonars-clinvar-minimal-grch37-20231112+0.25.0.tar.gz
wget -O /tmp/annonars-clinvar-minimal-grch38-20231112+0.25.0.tar.gz \
  https://github.com/bihealth/annonars-data-clinvar/releases/download/annonars-data-clinvar-20231112/annonars-clinvar-minimal-grch38-20231112+0.25.0.tar.gz

tar -C .dev/volumes/reev-static/data/download/annonars/ \
  -xf /tmp/annonars-clinvar-minimal-grch37-20231112+0.25.0.tar.gz
tar -C .dev/volumes/reev-static/data/download/annonars \
  -xf /tmp/annonars-clinvar-minimal-grch38-20231112+0.25.0.tar.gz

rm -f .dev/volumes/reev-static/data/annonars/grch37/clinvar
ln -sr .dev/volumes/reev-static/data/download/annonars/annonars-clinvar-minimal-grch37-20231112+0.25.0 \
  .dev/volumes/reev-static/data/annonars/grch37/clinvar
rm -f .dev/volumes/reev-static/data/annonars/grch38/clinvar
ln -sr .dev/volumes/reev-static/data/download/annonars/annonars-clinvar-minimal-grch38-20231112+0.25.0 \
  .dev/volumes/reev-static/data/annonars/grch38/clinvar

wget -O /tmp/annonars-clinvar-genes-20231112+0.25.0.tar.gz \
  https://github.com/bihealth/annonars-data-clinvar/releases/download/annonars-data-clinvar-20231112/annonars-clinvar-genes-20231112+0.25.0.tar.gz
tar -C .dev/volumes/reev-static/data/download/annonars \
  -xf /tmp/annonars-clinvar-genes-20231112+0.25.0.tar.gz

rm -f .dev/volumes/reev-static/data/annonars/clinvar-genes
ln -sr .dev/volumes/reev-static/data/download/annonars/annonars-clinvar-genes-20231112+0.25.0 \
  .dev/volumes/reev-static/data/annonars/clinvar-genes
```

To obtain data for dotty

```bash session
mkdir -p .dev/volumes/reev-static/data/download/dotty
pushd .dev/volumes/reev-static/data/download/dotty
wget \
    https://github.com/SACGF/cdot/releases/download/v0.2.21/cdot-0.2.21.ensembl.grch37.json.gz \
    https://github.com/SACGF/cdot/releases/download/v0.2.21/cdot-0.2.21.ensembl.grch38.json.gz \
    https://github.com/SACGF/cdot/releases/download/v0.2.21/cdot-0.2.21.refseq.grch37.json.gz \
    https://github.com/SACGF/cdot/releases/download/v0.2.21/cdot-0.2.21.refseq.grch38.json.gz
wget \
  https://github.com/bihealth/dotty/releases/download/v0.1.0/seqrepo.tar.gz-00 \
  https://github.com/bihealth/dotty/releases/download/v0.1.0/seqrepo.tar.gz-01
cat seqrepo.tar.gz-?? | tar xzf -
popd

mkdir -p .dev/volumes/reev-static/data/dotty
ln -sr .dev/volumes/reev-static/data/download/dotty/{*.json.gz,seqrepo} \
  .dev/volumes/reev-static/data/dotty
```

To obtain data for cada-prio

```bash session
mkdir -p .dev/volumes/reev-static/data/download/cada-prio
pushd .dev/volumes/reev-static/data/download/cada-prio
wget \
    https://github.com/bihealth/cada-prio-data/releases/download/cada-prio-data-20231112/cada-prio-model-20231112+0.6.1.tar.gz
tar -xzf cada-prio-model-20231112+0.6.1.tar.gz 
popd

mkdir -p .dev/volumes/reev-static/data/cada-prio
ln -sr .dev/volumes/reev-static/data/download/cada-prio/cada-prio-model-20231112+0.6.1/model/ \
  .dev/volumes/reev-static/data/cada
```

### Setup Configuration

The next step step is to create the configuration files in `.dev/config`.

```bash session
mkdir -p .dev/config/nginx
cp utils/nginx/nginx.conf .dev/config/nginx

mkdir -p .dev/config/pgadmin
cp utils/pgadmin/servers.json .dev/config/pgadmin
```

### Startup and Check

Now, you can bring up the docker compose environment (stop with `Ctrl+C`).

```bash session
docker compose up
```

To verify the results, have a look at the following URLs.
These URLs are used by the REEV application.

- Annonars database infos: http://127.0.0.1:3001/annos/db-info?genome_release=grch37
- Annonars gene info: http://0.0.0.0:3001/genes/info?hgnc_id=HGNC:12403
- Annonars variant info: http://0.0.0.0:3001/annos/variant?genome_release=grch37&chromosome=17&pos=41244100&reference=G&alternative=A
- Mehari impact prections: http://127.0.0.1:3002/tx/csq?genome-release=grch37&chromosome=17&position=48275363&reference=C&alternative=A
- Viguno for TGDS: http://127.0.0.1:3003/hpo/genes?gene_symbol=TGDS
- Nginx server with browser tracks http://127.0.0.1:3004/
- Dotty server with c./n./g. to SPDI resolution http://127.0.0.1:3005/api/v1/to-spdi?q=NM_000059.3:c.274G%3EA

Note that the development subset only has variants for a few genes, including BRCA1 (the example above).

You will also have the following services useful for introspection during development.
For production, you probably don't want to expose them publically.

- [flower](https://flower.readthedocs.io/en/latest/), login is `admin`, with password `flower-password`
- [pgAdmin](https://www.pgadmin.org/) for Postgres DB administration: http://127.0.0.1:3041 login is `admin@example.com` with password `pgadmin-password`

## Service Information

This section describes the services that are started with this Docker Compose.

### Traefik

[Traefik](https://traefik.io/traefik/) is a reverse proxy that is used as the main entry point for all services behind HTTP(S).
The software is well-documented by its creators.
However, it is central to the setup and for much of the additional setup, touching Trafik configuraiton is needed.
We thus summarize some important points here.

- Almost all configuration is done using labels on the `traefik` container itself or other containers.
- In the case of using configuration files, you will have to mount them from the host into the container.
- By default, we use "catch-all" configuration based on regular expressions on the host/domain name.

### Dotty

Dotty (by the REEV authors) provides mapping from c./n./g. notation to SPDI.

### Mehari

Mehari (by the REEV authors) provides information about variants and their effect on individual transcripts.

### Viguno

Viguno (by the REEV authors) provides HPO/OMIM related information.

### Annonars

Annonars (by the REEV authors) provides variant annotation from public databases.

### Postgres

We use postgres for the database backend of REEV.

### Rabbitmq

We use rabbitmq for message queues.

### Redis

REDIS is used for storing authentication sessions.

### PgAdmin

PgAdmin is a web-based administration tool for Postgres.
We provide it for development and debugging but it can also come in handy in production.

### Flower

Flower is a web-based application for monitoring and administrating Celery.

## Developer Info

### Managing GitHub Project with Terraform

```bash session
$ export GITHUB_OWNER=bihealth
$ export GITHUB_TOKEN=ghp_<thetoken>

$ cd utils/terraform
$ terraform init
$ terraform import github_repository.reev-docker-compose reev-docker-compose

$ terraform validate
$ terraform fmt
$ terraform plan
$ terraform apply
```
