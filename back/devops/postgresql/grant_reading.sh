#!/bin/sh

set -e

echo 'grant reading'

PGPASSWORD=$POSTGRESQL_PASSWORD_FULL psql \
  --username=$POSTGRESQL_USERNAME_FULL \
  --host=$POSTGRESQL_HOST \
  --port=$POSTGRESQL_PORT \
  --dbname="ai4cod_${RAILS_ENV}" \
  --command="
    REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM \"${POSTGRESQL_USERNAME}\";
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"${POSTGRESQL_USERNAME}\";
  "
