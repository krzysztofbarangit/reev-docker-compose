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

We provide a script that will setup the necessary directories, download the data, and create symlinks.

```bash session
bash download-data.sh
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
