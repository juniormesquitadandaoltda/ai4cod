#!/bin/sh

set -e

echo 'create user'

PGPASSWORD=$POSTGRESQL_PASSWORD_FULL psql \
  --username=$POSTGRESQL_USERNAME_FULL \
  --host=$POSTGRESQL_HOST \
  --port=$POSTGRESQL_PORT \
  --dbname="ai4cod_${RAILS_ENV}" \
  --command="
    DO \$\$
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_user WHERE usename = '${POSTGRESQL_USERNAME}' LIMIT 1) THEN
          CREATE USER \"${POSTGRESQL_USERNAME}\" WITH ENCRYPTED PASSWORD '${POSTGRESQL_PASSWORD}';
        END IF;
      END
    \$\$;
  "
