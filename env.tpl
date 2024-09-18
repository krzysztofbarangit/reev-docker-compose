# Template for an .env file.

# -- Stack Configuration -----------------------------------------------------

# Backend
BACKEND_CORS_ORIGINS=
SECRET_KEY=SECURITY-ALERT-REPLACE-THIS-KEY
FIRST_SUPERUSER=admin
FIRST_SUPERUSER_PASSWORD=SECURITY-ALERT-REPLACE-THIS
# SMTP_TLS=True
# SMTP_PORT=
# SMTP_HOST=
# SMTP_USER=
# SMTP_PASSWORD=
# EMAILS_FROM_EMAIL=
# Enable this on production only.
# CLINVAR_USE_PRODUCTION=1

# AutoACMG
AUTO_ACMG_API_ANNONARS_URL=http://annonars:8080
AUTO_ACMG_API_MEHARI_URL=http://mehari:8080
AUTO_ACMG_API_DOTTY_URL=http://dotty:8080
AUTO_ACMG_SEQREPO_DATA_DIR=/home/user/seqrepo/master

# Postgres
POSTGRES_SERVER=postgres
POSTGRES_USER=reev
POSTGRES_PASSWORD_FILE=/run/secrets/db-password
POSTGRES_DB=reev

# pgAdmin
PGADMIN_LISTEN_PORT=80
PGADMIN_DEFAULT_EMAIL=admin@example.com
PGADMIN_DEFAULT_PASSWORD_FILE=/run/secrets/pgadmin-password
PGADMIN_DISABLE_POSTFIX=1

# Flower
FLOWER_BASIC_AUTH=admin:flower-password

# Sentry setup.
# SENTRY_ENVIRONMENT=production

# -- Docker Images -----------------------------------------------------------

# Name of the registry server and org to use for our images.
# image_base=ghcr.io/bihealth

# Name of the dotty image to use.
# image_dotty_name=dotty

# Version of the dotty image to use.
# image_dotty_version=latest

# Name of the cada-prio image to use.
# image_cada_prio_name=cada-prio

# Version of the cada-prio image to use.
# image_cada_prio_version=main

# Name of the mehari image to use.
# image_mehari_name=mehari

# Version of the mehari image to use.
# image_mehari_version=latest

# Name of the viguno image to use.
# image_viguno_name=viguno

# Version of the viguno image to use.
# image_viguno_version=latest

# Name of the annonars image to use.
# image_annonars_name=annonars

# Version of the annonars image to use.
# image_annonars_version=latest

# Name of the traefik image to use.
# image_traefik_name=traefik

# Version of the traefik image to use.
# image_traefik_version=2.10

# Name of the postgres image to use.
# image_postgres_name=postgres

# Version of the postgres image to use.
# image_postgres_version=12

# Name of the redis image to use.
# image_redis_name=redisq

# Version of the redis image to use.
# image_redis_version=7

# Name of the rabbitmq image to use.
# image_rabbitmq_name=rabbitmq

# Version of the rabbitmq image to use.
# image_rabbitmq_version=3

# Name of the flower image to use.
# image_flower_name=mher/flower

# Version of the flower image to use.
# image_flower_version=latest

# Name of the pgadmin image to use.
# image_pgadmin_name=dpage/pgadmin4

# Version of the pgadmin image to use
# image_pgadmin_version=latest

# Name of the reev image to use.
# image_reev_name=reev

# Version of the reev image to use.
# image_reev_version=main

# Name of the nginx image to use.
# image_nginx_name=nginx

# Version of the nginx image to use.
# image_nginx_version=1

# -- General Container Configuration -----------------------------------------

# Base directory for configuration.
# config_basedir: ./.dev/config

# Base directory for volumes.
# volumes_basedir: ./.dev/volumes

# Base directory for secrets.
# secrets_basedir: ./.dev/secrets

