#!/usr/bin/bash

# Inofficial Bash Strict Mode
#
# cf. http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# -- Configuration ------------------------------------------------------------

# QUIET=1 mode: suppress all output except errors.
export QUIET=${QUIET-0}
# VERBOSE=1 mode: print all commands before executing them.
export VERBOSE=${VERBOSE-0}
# Dry-run mode.
export DRY_RUN=${DRY_RUN-0}
# No-verify-ssl mode: do not verify SSL certificates.
export NO_VERIFY_SSL=${NO_VERIFY_SSL-0}
# Download options: reduced-dev (default), reduced-exomes, full.
export DOWNLOAD=${DOWNLOAD-reduced-dev}
# Directory for static data.
export STATIC_DIR=${STATIC_DIR-reev-static}
# Overall directory prefix.
export DIR_PREFIX=${DIR_PREFIX-.dev}
# Overall static data directory.
export DATA_DIR=${DATA_DIR-$DIR_PREFIX/volumes/$STATIC_DIR/data}
# S3 endpoing URL.
export S3_ENDPOINT_URL=https://ceph-s3-public.cubi.bihealth.org

# Set S5CMD_NO_VERIFY_SSL_ARG based on NO_VERIFY_SSL
if [ "$NO_VERIFY_SSL" -eq 1 ]; then
    S5CMD_NO_VERIFY_SSL_ARG="--no-verify-ssl"
else
    S5CMD_NO_VERIFY_SSL_ARG=""
fi

# -- Versions -----------------------------------------------------------------

# annonars
export V_ANNONARS=${V_ANNONARS-0.33.0}
# viguno
export V_VIGUNO=${V_VIGUNO-0.2.0}
# VarFish Worker
export V_WORKER=${V_WORKER-0.10.2}

# CADD
export V_CADD=${V_CADD-1.6}
# UCSC 100 vertebrate conservation GRCh37
export V_UCSC_CONS_37=${V_UCSC_CONS_37-20161007}
# UCSC 100 vertebrate conservation GRCh38
export V_UCSC_CONS_38=${V_UCSC_CONS_38-20190906}
# dbNSFP
export V_DBNSFP=${V_DBNSFP-4.5a}
# dbNSFP (no suffix)
export V_DBNSFP_NO_SUFFIX=${V_DBNSFP%a}
export V_DBNSFP_NO_SUFFIX=${V_DBNSFP_NO_SUFFIX%c}
# dbSCSNV
export V_DBSCSNV=${V_DBSCSNV-1.1}
# dbSNP
export V_DBSNP=${V_DBSNP-b151}
# RefSeq functional GRCh37
export V_REFSEQ_GRCH37=${V_REFSEQ_GRCH37-105.20201022}
# RefSeq functional GRCh38
export V_REFSEQ_GRCH38=${V_REFSEQ_GRCH38-110}
# ACMG SF list
export V_ACMG_SF=${V_ACMG_SF-3.1}
# gnomAD constraints
export V_GNOMAD_CONSTRAINTS=${V_GNOMAD_CONSTRAINTS-4.0}
# HPO release
export V_HPO=${V_HPO-20230606}
# OrphaPackets release
export V_ORPHAPACKETS=${V_ORPHAPACKETS-10.1}
# VarFish DB Download Data
export V_VARFISHDB=${V_VARFISHDB-20240105}
# gnomAD exomes GRCh37
export V_GNOMAD_EXOMES_GRCH37=${V_GNOMAD_EXOMES_GRCH37-2.1.1}
# gnomAD exomes GRCh38
export V_GNOMAD_EXOMES_GRCH38=${V_GNOMAD_EXOMES_GRCH38-4.0}
# gnomAD genomes GRCh37
export V_GNOMAD_GENOMES_GRCH37=${V_GNOMAD_GENOMES_GRCH37-2.1.1}
# gnomAD genomes GRCh38
export V_GNOMAD_GENOMES_GRCH38=${V_GNOMAD_GENOMES_GRCH38-4.0}
# gnomAD mtDNA
export V_GNOMAD_MT=${V_GNOMAD_MT-3.1}
# gnomAD SVs exomes GRCh37 (== ExAC)
export V_GNOMAD_EXOMES_SVS_GRCH37=${V_GNOMAD_EXOMES_SVS_GRCH37-0.3.1}
# gnomAD SVs exomes GRCh38
export V_GNOMAD_EXOMES_SVS_GRCH38=${V_GNOMAD_EXOMES_SVS_GRCH38-4.0}
# gnomAD SV genomes GRCh37
export V_GNOMAD_GENOMES_SV_GRCH37=${V_GNOMAD_GENOMES_SV_GRCH37-2.1.1}
# gnomAD SV genomes GRCh38
export V_GNOMAD_GENOMES_SV_GRCH38=${V_GNOMAD_GENOMES_SV_GRCH38-4.0}
# HelixMtDB
export V_HELIXMTDB=${V_HELIXMTDB-20200327}
# ClinGen Regions
export V_CLINGEN_REGIONS=${V_CLINGEN_REGIONS-20240105}

# Mehari Gene ID Xlink
export V_MEHARI_XLINK=${V_MEHARI_XLINK-20240105}
# Mehari Transcripts
export V_MEHARI_TXS=${V_MEHARI_TXS-0.4.4}

# dbVar version
export V_DBVAR=${V_DBVAR-20231030}
# DGV version
export V_DGV=${V_DGV-20200225}
# 1000 Genomes Version
export V_G1K=${V_G1K-phase3v2}
# ClinVar Strucvars
export V_CLINVAR_STRUCVARS=${V_CLINVAR_STRUCVARS-20230625}
# Genes ENSEMBL GRCh37
export V_GENES_ENSEMBL_GRCH37=${V_GENES_ENSEMBL_GRCH37-87}
# Genes ENSEMBL GRCh38
export V_GENES_ENSEMBL_GRCH38=${V_GENES_ENSEMBL_GRCH38-109}
# Genes RefSeq GRCh37
export V_GENES_REFSEQ_GRCH37=${V_GENES_REFSEQ_GRCH37-105.20201022}
# Genes RefSeq GRCh38
export V_GENES_REFSEQ_GRCH38=${V_GENES_REFSEQ_GRCH38-GCF_000001405.40+RS_2023_03}
# UCSC rmsk GRCh37
export V_UCSC_RMSK_37=${V_UCSC_RMSK_37-20200322}
# UCSC rmsk GRCh38
export V_UCSC_RMSK_38=${V_UCSC_RMSK_38-20221018}
# UCSC genomicSuperDups GRCh37
export V_UCSC_GENOMIC_SUPER_DUPS_37=${V_UCSC_GENOMIC_SUPER_DUPS_37-20111025}
# UCSC genomicSuperDups GRCh38
export V_UCSC_GENOMIC_SUPER_DUPS_38=${V_UCSC_GENOMIC_SUPER_DUPS_38-20141019}
# UCSC altSeqLiftover GRCh37
export V_UCSC_ALT_SEQ_LIFTOVER_37=${V_UCSC_ALT_SEQ_LIFTOVER_37-20200322}
# UCSC altSeqLiftover GRCh38
export V_UCSC_ALT_SEQ_LIFTOVER_38=${V_UCSC_ALT_SEQ_LIFTOVER_38-20221103}
# Patho MMS
export V_PATHO_MMS=${V_PATHO_MMS-20220730}

# annonars-data-clinvar clinvar
export V_ANNONARS_DATA_CLINVAR_CLINVAR=${V_ANNONARS_DATA_CLINVAR_CLINVAR-20231231}
# annonars-data-gnomad annonars
export V_ANNONARS_DATA_CLINVAR_ANNONARS=${V_ANNONARS_DATA_CLINVAR_ANNONARS-0.31.0}
# dotty-seqrepo
export V_DOTTY_SEQREPO=${V_DOTTY_SEQREPO-0.1.0}

# dotty-cdot-version
export V_DOTTY_CDOT_VERSION=${V_DOTTY_CDOT_VERSION-0.2.21}

# cada-prio model
export V_CADA_PRIO_MODEL=${V_CADA_PRIO_MODEL-20231112}
# cada-prio version
export V_CADA_PRIO_VERSION=${V_CADA_PRIO_VERSION-0.6.1}

# -- Verbose Mode -------------------------------------------------------------

# Use "set -x" if verbose and unless quiet.
if [[ "$QUIET" -eq 0 ]] && [[ "$VERBOSE" -ne 0 ]]; then
    set -x
fi

# -- Logging ------------------------------------------------------------------

# Logging in info mode.
log_info()
{
    [[ $QUIET -eq 0 ]] && echo "[$(set +x; date +%T.%3N)] INFO: $*" >&2
}

# Logging in debug mode.
log_debug()
{
    [[ $VERBOSE -ne 0 ]] && echo "[$(set +x; date +%T.%3N)] DBG:  $*" >&2
}

# Logging in error mode.
log_error()
{
    echo "[$(set +x; date +%T.%3N)] ERROR: $*" >&2
}

# -- Helper Functions ---------------------------------------------------------

# Return prefix for the given download directory.
#
#   prefix_for <prefix>
#
# Example:
#
#   prefix_for annonars/cadd-grch37-1.6+0.29.1
prefix_for()
{
    for prefix in annonars/cadd annonars/cons annonars/dbnsfp annonars/dbscsnv \
            annonars/dbsnp annonars/gnomad-exomes annonars/gnomad-genomes \
            mehari/freqs viguno/hpo; do
        if [[ $1 == $prefix* ]]; then
            # have reduced
            echo $DOWNLOAD
            return
        fi
    done
    # no reduced available
    echo full
}

# Depending on $DRY_RUN, either execute the given command or print it.
run()
{
    if [[ $DRY_RUN -eq 0 ]]; then
        "$@"
    else
        echo "$@"
    fi
}

# -- Downloading --------------------------------------------------------------

log_info "Download data ..."

# First, write out folders that we want to download.
cat <<EOF >/tmp/download-list.txt
annonars/cadd-grch37-$V_CADD+$V_ANNONARS
annonars/cadd-grch38-$V_CADD+$V_ANNONARS
annonars/cons-grch37-$V_UCSC_CONS_37+$V_ANNONARS
annonars/cons-grch38-$V_UCSC_CONS_38+$V_ANNONARS
annonars/dbnsfp-grch37-$V_DBNSFP+$V_ANNONARS
annonars/dbnsfp-grch38-$V_DBNSFP+$V_ANNONARS
annonars/dbscsnv-grch37-$V_DBSCSNV+$V_ANNONARS
annonars/dbscsnv-grch38-$V_DBSCSNV+$V_ANNONARS
annonars/dbsnp-grch37-$V_DBSNP+$V_ANNONARS
annonars/dbsnp-grch38-$V_DBSNP+$V_ANNONARS
annonars/functional-grch37-$V_REFSEQ_GRCH37+$V_ANNONARS
annonars/functional-grch38-$V_REFSEQ_GRCH38+$V_ANNONARS
annonars/genes-$V_ACMG_SF+$V_GNOMAD_CONSTRAINTS+$V_DBNSFP_NO_SUFFIX+$V_HPO+$V_ORPHAPACKETS+$V_VARFISHDB+$V_ANNONARS
annonars/gnomad-exomes-grch37-$V_GNOMAD_EXOMES_GRCH37+$V_ANNONARS
annonars/gnomad-exomes-grch38-$V_GNOMAD_EXOMES_GRCH38+$V_ANNONARS
annonars/gnomad-genomes-grch37-$V_GNOMAD_EXOMES_GRCH37+$V_ANNONARS
annonars/gnomad-genomes-grch38-$V_GNOMAD_EXOMES_GRCH38+$V_ANNONARS
annonars/gnomad-mtdna-grch37-$V_GNOMAD_MT+$V_ANNONARS
annonars/gnomad-mtdna-grch38-$V_GNOMAD_MT+$V_ANNONARS
annonars/gnomad-sv-exomes-grch37-$V_GNOMAD_EXOMES_SVS_GRCH37+$V_ANNONARS
annonars/gnomad-sv-exomes-grch38-$V_GNOMAD_EXOMES_SVS_GRCH38+$V_ANNONARS
annonars/gnomad-sv-genomes-grch37-$V_GNOMAD_EXOMES_GRCH37+$V_ANNONARS
annonars/gnomad-sv-genomes-grch38-$V_GNOMAD_GENOMES_GRCH38+$V_ANNONARS
annonars/helixmtdb-grch37-$V_HELIXMTDB+$V_ANNONARS
annonars/helixmtdb-grch38-$V_HELIXMTDB+$V_ANNONARS
annonars/regions-grch37-$V_CLINGEN_REGIONS+$V_ANNONARS
annonars/regions-grch38-$V_CLINGEN_REGIONS+$V_ANNONARS
mehari/freqs-grch37-$V_GNOMAD_EXOMES_GRCH37+$V_GNOMAD_GENOMES_GRCH37+$V_GNOMAD_MT+$V_HELIXMTDB+$V_ANNONARS
mehari/freqs-grch38-$V_GNOMAD_EXOMES_GRCH38+$V_GNOMAD_GENOMES_GRCH38+$V_GNOMAD_MT+$V_HELIXMTDB+$V_ANNONARS
mehari/genes-xlink-$V_MEHARI_XLINK
tracks
worker
viguno/hpo-$V_HPO+$V_VIGUNO
EOF
# Create download directory.
mkdir -p $DATA_DIR/download
# Download each entry from download list.  Note that we support commenting
# out lines with a leading "#".
grep -v ^# /tmp/download-list.txt >/tmp/download-list.nocomment.txt
while read -r line; do
    # Create the download directory.
    run mkdir -p $DATA_DIR/download/$line
    # Actually download the data.
    log_info "s3://varfish-public/$(prefix_for $line)/$line/* -> $DATA_DIR/download/$line"
    run s5cmd \
        --endpoint-url=$S3_ENDPOINT_URL \
        --no-sign-request \
        $S5CMD_NO_VERIFY_SSL_ARG \
        sync \
        "s3://varfish-public/$(prefix_for $line)/$line/*" \
        $DATA_DIR/download/$line \
    &> >(tee /tmp/download.stderr >&2)
    grep ^ERROR /tmp/download.stderr >/dev/null && exit 1
done </tmp/download-list.nocomment.txt

log_info "... done downloading data."

log_info "Setup symlink structure ..."

log_info "- annonars"
mkdir -p $DATA_DIR/annonars/{grch37,grch38}

rm -f $DATA_DIR/annonars/genes
ln -sr \
    $DATA_DIR/download/annonars/genes-$V_ACMG_SF+$V_GNOMAD_CONSTRAINTS+$V_DBNSFP_NO_SUFFIX+$V_HPO+$V_ORPHAPACKETS+$V_VARFISHDB+$V_ANNONARS \
    $DATA_DIR/annonars/genes

# cadd - GRCh37
rm -f $DATA_DIR/annonars/grch37/cadd
ln -sr \
    $DATA_DIR/download/annonars/cadd-grch37-$V_CADD+$V_ANNONARS \
    $DATA_DIR/annonars/grch37/cadd
# cadd - GRCh38
rm -f $DATA_DIR/annonars/grch38/cadd
ln -sr \
    $DATA_DIR/download/annonars/cadd-grch38-$V_CADD+$V_ANNONARS \
    $DATA_DIR/annonars/grch38/cadd

# dbsnp - GRCh37
rm -f $DATA_DIR/annonars/grch37/dbsnp
ln -sr \
    $DATA_DIR/download/annonars/dbsnp-grch37-$V_DBSNP+$V_ANNONARS \
    $DATA_DIR/annonars/grch37/dbsnp
# dbsnp - GRCh38
rm -f $DATA_DIR/annonars/grch38/dbsnp
ln -sr \
    $DATA_DIR/download/annonars/dbsnp-grch38-$V_DBSNP+$V_ANNONARS \
    $DATA_DIR/annonars/grch38/dbsnp

# dbnsfp - GRCh37
rm -f $DATA_DIR/annonars/grch37/dbnsfp
ln -sr \
    $DATA_DIR/download/annonars/dbnsfp-grch37-$V_DBNSFP+$V_ANNONARS \
    $DATA_DIR/annonars/grch37/dbnsfp
# dbnsfp - GRCh38
rm -f $DATA_DIR/annonars/grch38/dbnsfp
ln -sr \
    $DATA_DIR/download/annonars/dbnsfp-grch38-$V_DBNSFP+$V_ANNONARS \
    $DATA_DIR/annonars/grch38/dbnsfp

# dbscsnv - GRCh37
rm -f $DATA_DIR/annonars/grch37/dbscsnv
ln -sr \
    $DATA_DIR/download/annonars/dbscsnv-grch37-$V_DBSCSNV+$V_ANNONARS \
    $DATA_DIR/annonars/grch37/dbscsnv
# dbscsnv - GRCh38
rm -f $DATA_DIR/annonars/grch38/dbscsnv
ln -sr \
    $DATA_DIR/download/annonars/dbscsnv-grch38-$V_DBSCSNV+$V_ANNONARS \
    $DATA_DIR/annonars/grch38/dbscsnv

# gnomad-mtdna - GRCh37
rm -f $DATA_DIR/annonars/grch37/gnomad-mtdna
ln -sr \
    $DATA_DIR/download/annonars/gnomad-mtdna-grch37-$V_GNOMAD_MT+$V_ANNONARS \
    $DATA_DIR/annonars/grch37/gnomad-mtdna
# gnomad-mtdna - GRCh38
rm -f $DATA_DIR/annonars/grch38/gnomad-mtdna
ln -sr \
    $DATA_DIR/download/annonars/gnomad-mtdna-grch38-$V_GNOMAD_MT+$V_ANNONARS \
    $DATA_DIR/annonars/grch38/gnomad-mtdna

# helixmtdb - GRCh37
rm -f $DATA_DIR/annonars/grch37/helixmtdb
ln -sr \
    $DATA_DIR/download/annonars/helixmtdb-grch37-$V_HELIXMTDB+$V_ANNONARS \
    $DATA_DIR/annonars/grch37/helixmtdb
# helixmtdb - GRCh38
rm -f $DATA_DIR/annonars/grch38/helixmtdb
ln -sr \
    $DATA_DIR/download/annonars/helixmtdb-grch38-$V_HELIXMTDB+$V_ANNONARS \
    $DATA_DIR/annonars/grch38/helixmtdb

# gnomad-genomes - GRCh37
rm -f $DATA_DIR/annonars/grch37/gnomad-genomes
ln -sr \
    $DATA_DIR/download/annonars/gnomad-genomes-grch37-$V_GNOMAD_GENOMES_GRCH37+$V_ANNONARS \
    $DATA_DIR/annonars/grch37/gnomad-genomes
# gnomad-genomes - GRCh38
rm -f $DATA_DIR/annonars/grch38/gnomad-genomes
ln -sr \
    $DATA_DIR/download/annonars/gnomad-genomes-grch38-$V_GNOMAD_GENOMES_GRCH38+$V_ANNONARS \
    $DATA_DIR/annonars/grch38/gnomad-genomes

# gnomad-exomes - GRCh37
rm -f $DATA_DIR/annonars/grch37/gnomad-exomes
ln -sr \
    $DATA_DIR/download/annonars/gnomad-exomes-grch37-$V_GNOMAD_EXOMES_GRCH37+$V_ANNONARS \
    $DATA_DIR/annonars/grch37/gnomad-exomes
# gnomad-exomes - GRCh38
rm -f $DATA_DIR/annonars/grch38/gnomad-exomes
ln -sr \
    $DATA_DIR/download/annonars/gnomad-exomes-grch38-$V_GNOMAD_EXOMES_GRCH38+$V_ANNONARS \
    $DATA_DIR/annonars/grch38/gnomad-exomes

# cons - GRCh37
rm -f $DATA_DIR/annonars/grch37/cons
ln -sr \
    $DATA_DIR/download/annonars/cons-grch37-$V_UCSC_CONS_37+$V_ANNONARS \
    $DATA_DIR/annonars/grch37/cons
# cons - GRCh38
rm -f $DATA_DIR/annonars/grch38/cons
ln -sr \
    $DATA_DIR/download/annonars/cons-grch38-$V_UCSC_CONS_38+$V_ANNONARS \
    $DATA_DIR/annonars/grch38/cons

log_info "- mehari"
mkdir -p $DATA_DIR/mehari/{grch37,grch38}

# freqs - GRCh37
rm -f $DATA_DIR/mehari/grch37/freqs
ln -sr \
    $DATA_DIR/download/mehari/freqs-grch37-$V_GNOMAD_EXOMES_GRCH37+$V_GNOMAD_GENOMES_GRCH37+$V_GNOMAD_MT+$V_HELIXMTDB+$V_ANNONARS \
    $DATA_DIR/mehari/grch37/freqs
# freqs - GRCh38
rm -f $DATA_DIR/mehari/grch38/freqs
ln -sr \
    $DATA_DIR/download/mehari/freqs-grch38-$V_GNOMAD_EXOMES_GRCH38+$V_GNOMAD_GENOMES_GRCH38+$V_GNOMAD_MT+$V_HELIXMTDB+$V_ANNONARS \
    $DATA_DIR/mehari/grch38/freqs

log_info "- viguno"
mkdir -p $DATA_DIR/viguno

# xlink
rm -f $DATA_DIR/hgnc_xlink.tsv
ln -sr \
    $DATA_DIR/download/mehari/genes-xlink-$V_VARFISHDB/genes-xlink.tsv \
    $DATA_DIR/hgnc_xlink.tsv
# hpo
rm -f $DATA_DIR/hpo
ln -sr \
    $DATA_DIR/download/viguno/hpo-$V_HPO+$V_VIGUNO \
    $DATA_DIR/hpo

log_info "- worker"
mkdir -p $DATA_DIR/worker/grch3{7,8}/strucvars/bgdbs

log_info "  - strucvars/bgdbs"
rm -f $DATA_DIR/worker/grch3{7,8}/strucvars/bgdbs/{exac,g1k,gnomad,dbvar,dgv,dgv-gs}.bin
ln -sr $(echo $DATA_DIR/download/worker/bgdb-exac-grch37-*/bgdb-exac.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/strucvars/bgdbs/exac.bin
ln -sr $(echo $DATA_DIR/download/worker/bgdb-g1k-grch37-$V_G1K+$V_WORKER/bgdb-g1k.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/strucvars/bgdbs/g1k.bin
ln -sr $(echo $DATA_DIR/download/worker/bgdb-gnomad-grch37-*/bgdb-gnomad.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/strucvars/bgdbs/gnomad.bin
ln -sr $(echo $DATA_DIR/download/worker/bgdb-dbvar-grch37-*/bgdb-dbvar.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/strucvars/bgdbs/dbvar.bin
ln -sr $(echo $DATA_DIR/download/worker/bgdb-dbvar-grch38-*/bgdb-dbvar.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch38/strucvars/bgdbs/dbvar.bin
ln -sr $(echo $DATA_DIR/download/worker/bgdb-dgv-grch37-*/bgdb-dgv.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/strucvars/bgdbs/dgv.bin
ln -sr $(echo $DATA_DIR/download/worker/bgdb-dgv-grch38-*/bgdb-dgv.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch38/strucvars/bgdbs/dgv.bin
ln -sr $(echo $DATA_DIR/download/worker/bgdb-dgv-gs-grch37-*/bgdb-dgv-gs.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/strucvars/bgdbs/dgv-gs.bin
ln -sr $(echo $DATA_DIR/download/worker/bgdb-dgv-gs-grch38-*/bgdb-dgv-gs.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch38/strucvars/bgdbs/dgv-gs.bin

log_info "  - strucvars/clinvar"
rm -f $DATA_DIR/worker/grch3{7,8}/strucvars/clinvar.bin

ln -sr $(ls $DATA_DIR/download/worker/clinvar-strucvars-grch37-*/clinvar-strucvars.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/strucvars/clinvar.bin
ln -sr $(ls $DATA_DIR/download/worker/clinvar-strucvars-grch38-*/clinvar-strucvars.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch38/strucvars/clinvar.bin

log_info "  - strucvars/patho-mms"
rm -f $DATA_DIR/worker/grch3?/strucvars/patho-mms.bed

ln -sr $(ls $DATA_DIR/download/worker/patho-mms-grch37-*/patho-mms.bed | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/strucvars/patho-mms.bed
ln -sr $(ls $DATA_DIR/download/worker/patho-mms-grch38-*/patho-mms.bed | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch38/strucvars/patho-mms.bed

log_info "  - strucvars/tads"
mkdir -p $DATA_DIR/worker/grch3{7,8}/tads
rm -f $DATA_DIR/worker/grch3?/tads/hesc.bed

ln -sr $(ls $DATA_DIR/download/worker/tads-grch37-dixon2015/hesc.bed | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/tads/hesc.bed
ln -sr $(ls $DATA_DIR/download/worker/tads-grch38-dixon2015/hesc.bed | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch38/tads/hesc.bed

log_info "  - noref/genes"
mkdir -p $DATA_DIR/worker/noref/genes
rm -f $DATA_DIR/worker/noref/genes/{xlink.bin,acmg.tsv,mime2gene.tsv}

ln -sr $(ls $DATA_DIR/download/worker/genes-xlink-*/genes-xlink.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/noref/genes/xlink.bin
ln -sr $(ls $DATA_DIR/download/worker/acmg-sf-*/acmg_sf.tsv | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/noref/genes/acmg.tsv
ln -sr $(ls $DATA_DIR/download/worker/mim2gene-*/mim2gene.tsv | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/noref/genes/mime2gene.tsv

log_info "  - grch3{7,8}/regions"
mkdir -p $DATA_DIR/worker/grch3{7,8}/genes
rm -f $DATA_DIR/worker/grch3?/genes/{ensembl_genes.bin,refseq_genes.bin}

ln -sr $(ls $DATA_DIR/download/worker/genes-regions-grch37-*/ensembl_genes.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/genes/ensembl_genes.bin
ln -sr $(ls $DATA_DIR/download/worker/genes-regions-grch38-*/ensembl_genes.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch38/genes/ensembl_genes.bin

ln -sr $(ls $DATA_DIR/download/worker/genes-regions-grch37-*/refseq_genes.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/genes/refseq_genes.bin
ln -sr $(ls $DATA_DIR/download/worker/genes-regions-grch38-*/refseq_genes.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch38/genes/refseq_genes.bin

log_info "  - grch3{7,8}/features"
mkdir -p $DATA_DIR/worker/grch3{7,8}/features
rm -f $DATA_DIR/worker/grch3?/features/{masked_repeat.bin,masked_seqdup.bin}

ln -sr $(ls $DATA_DIR/download/worker/masked-repeat-grch37-*/masked-repeat.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/features/masked_repeat.bin
ln -sr $(ls $DATA_DIR/download/worker/masked-segdup-grch37-*/masked-segdup.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch37/features/masked_seqdup.bin

ln -sr $(ls $DATA_DIR/download/worker/masked-repeat-grch38-*/masked-repeat.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch38/features/masked_repeat.bin
ln -sr $(ls $DATA_DIR/download/worker/masked-segdup-grch38-*/masked-segdup.bin | tr ' ' '\n' | tail -n 1) \
  $DATA_DIR/worker/grch38/features/masked_seqdup.bin

log_info "- tracks"

mkdir -p $DATA_DIR/nginx/grch3{7,8}
rm -f $DATA_DIR/nginx/grch3{7,8}/*

for release in grch37 grch38; do
  paths_release=$(find $DATA_DIR/download/tracks/ -type f -name '*.bed' -or -name '*.bed.gz' | sort | grep $release)
  for path in $paths_release; do
    if [[ -e ${path}.tbi ]]; then
      rm -f $DATA_DIR/nginx/$release/$(basename $path)
      rm -f $DATA_DIR/nginx/$release/$(basename $path).tbi
      ln -sr $path ${path}.tbi $DATA_DIR/nginx/$release
    else
      rm -f $DATA_DIR/nginx/$release/$(basename $path)
      ln -sr $path $DATA_DIR/nginx/$release
    fi
  done
done

log_info "... done setting up symlink structure."

log_info "- mehari transcripts"

mkdir -p $DATA_DIR/download/mehari-data-txs-grch3{7,8}

for ext in .zst .zst.sha256 .zst.report .zst.report.sha256; do
  for release in grch37 grch38; do
    wget -q -c -O $DATA_DIR/download/mehari-data-txs-$release/mehari-data-txs-$release-$V_MEHARI_TXS.bin$ext \
      https://github.com/bihealth/mehari-data-tx/releases/download/v$V_MEHARI_TXS/mehari-data-txs-$release-$V_MEHARI_TXS.bin$ext
  done
done

for release in grch37 grch38; do
  rm -f $DATA_DIR/mehari/$release/txs.bin.zst
  ln -sr $DATA_DIR/download/mehari-data-txs-$release/mehari-data-txs-$release-$V_MEHARI_TXS.bin.zst \
    $DATA_DIR/mehari/$release/txs.bin.zst
done

log_info "- clinvar"

wget -q -c -O /tmp/annonars-clinvar-minimal-grch37-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz \
  https://github.com/bihealth/annonars-data-clinvar/releases/download/annonars-data-clinvar-$V_ANNONARS_DATA_CLINVAR_CLINVAR/annonars-clinvar-minimal-grch37-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz
wget -q -c -O /tmp/annonars-clinvar-minimal-grch38-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz \
  https://github.com/bihealth/annonars-data-clinvar/releases/download/annonars-data-clinvar-$V_ANNONARS_DATA_CLINVAR_CLINVAR/annonars-clinvar-minimal-grch38-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz

tar -C $DATA_DIR/download/annonars/ \
  -xf /tmp/annonars-clinvar-minimal-grch37-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz
tar -C $DATA_DIR/download/annonars \
  -xf /tmp/annonars-clinvar-minimal-grch38-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz

rm -f $DATA_DIR/annonars/grch37/clinvar
ln -sr $DATA_DIR/download/annonars/annonars-clinvar-minimal-grch37-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS \
  $DATA_DIR/annonars/grch37/clinvar
rm -f $DATA_DIR/annonars/grch38/clinvar
ln -sr $DATA_DIR/download/annonars/annonars-clinvar-minimal-grch38-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS \
  $DATA_DIR/annonars/grch38/clinvar

wget -q -c -O /tmp/annonars-clinvar-genes-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz \
  https://github.com/bihealth/annonars-data-clinvar/releases/download/annonars-data-clinvar-$V_ANNONARS_DATA_CLINVAR_CLINVAR/annonars-clinvar-genes-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz
tar -C $DATA_DIR/download/annonars \
  -xf /tmp/annonars-clinvar-genes-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz

rm -f $DATA_DIR/annonars/clinvar-genes
ln -sr $DATA_DIR/download/annonars/annonars-clinvar-genes-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS \
  $DATA_DIR/annonars/clinvar-genes

wget -q -c -O /tmp/annonars-clinvar-sv-grch37-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz \
  https://github.com/bihealth/annonars-data-clinvar/releases/download/annonars-data-clinvar-$V_ANNONARS_DATA_CLINVAR_CLINVAR/annonars-clinvar-sv-grch37-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz
wget -q -c -O /tmp/annonars-clinvar-sv-grch38-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz \
  https://github.com/bihealth/annonars-data-clinvar/releases/download/annonars-data-clinvar-$V_ANNONARS_DATA_CLINVAR_CLINVAR/annonars-clinvar-sv-grch38-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz
tar -C $DATA_DIR/download/annonars/ \
  -xf /tmp/annonars-clinvar-sv-grch37-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz
tar -C $DATA_DIR/download/annonars/ \
  -xf /tmp/annonars-clinvar-sv-grch38-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS.tar.gz
rm -f $DATA_DIR/annonars/grch3{7,8}/clinvar-sv
ln -sr $DATA_DIR/download/annonars/annonars-clinvar-sv-grch37-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS \
  $DATA_DIR/annonars/grch37/clinvar-sv
ln -sr $DATA_DIR/download/annonars/annonars-clinvar-sv-grch38-$V_ANNONARS_DATA_CLINVAR_CLINVAR+$V_ANNONARS_DATA_CLINVAR_ANNONARS \
  $DATA_DIR/annonars/grch38/clinvar-sv

log_info "- dotty"

mkdir -p $DIR_PREFIX/volumes/$STATIC_DIR/data/download/dotty
pushd $DIR_PREFIX/volumes/$STATIC_DIR/data/download/dotty >/dev/null
wget -q -c \
    https://github.com/SACGF/cdot/releases/download/v$V_DOTTY_CDOT_VERSION/cdot-$V_DOTTY_CDOT_VERSION.ensembl.grch37.json.gz \
    https://github.com/SACGF/cdot/releases/download/v$V_DOTTY_CDOT_VERSION/cdot-$V_DOTTY_CDOT_VERSION.ensembl.grch38.json.gz \
    https://github.com/SACGF/cdot/releases/download/v$V_DOTTY_CDOT_VERSION/cdot-$V_DOTTY_CDOT_VERSION.refseq.grch37.json.gz \
    https://github.com/SACGF/cdot/releases/download/v$V_DOTTY_CDOT_VERSION/cdot-$V_DOTTY_CDOT_VERSION.refseq.grch38.json.gz
wget -q -c \
  https://github.com/bihealth/dotty/releases/download/v$V_DOTTY_SEQREPO/seqrepo.tar.gz-00 \
  https://github.com/bihealth/dotty/releases/download/v$V_DOTTY_SEQREPO/seqrepo.tar.gz-01
cat seqrepo.tar.gz-?? | tar -xzf -
popd >/dev/null

mkdir -p $DIR_PREFIX/volumes/$STATIC_DIR/data/dotty
rm -f $DIR_PREFIX/volumes/$STATIC_DIR/data/dotty/{*.json.gz,seqrepo}
ln -sr $DIR_PREFIX/volumes/$STATIC_DIR/data/download/dotty/{*.json.gz,seqrepo} \
  $DIR_PREFIX/volumes/$STATIC_DIR/data/dotty

log_info "- cada-prio"

mkdir -p $DIR_PREFIX/volumes/$STATIC_DIR/data/download/cada
pushd $DIR_PREFIX/volumes/$STATIC_DIR/data/download/cada >/dev/null
wget -q -c \
    https://github.com/bihealth/cada-prio-data/releases/download/cada-prio-data-$V_CADA_PRIO_MODEL/cada-prio-model-$V_CADA_PRIO_MODEL+$V_CADA_PRIO_VERSION.tar.gz
tar -xzf cada-prio-model-$V_CADA_PRIO_MODEL+$V_CADA_PRIO_VERSION.tar.gz
popd >/dev/null

mkdir -p $DIR_PREFIX/volumes/$STATIC_DIR/data/cada
rm -f $DIR_PREFIX/volumes/$STATIC_DIR/data/cada/model

source_dir="$DIR_PREFIX/volumes/$STATIC_DIR/data/download/cada/cada-prio-model-$V_CADA_PRIO_MODEL+$V_CADA_PRIO_VERSION/model"
for file in "${source_dir}"/*; do
  rm -f "$DIR_PREFIX/volumes/$STATIC_DIR/data/cada/$(basename "$file")"
  ln -sr "$file" "$DIR_PREFIX/volumes/$STATIC_DIR/data/cada/"
done
