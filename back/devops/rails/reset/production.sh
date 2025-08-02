#!/bin/sh

set -e

RAILS_ENV=development POSTGRESQL_DATABASE=ai4cod_production rails db:environment:set || echo

RAILS_ENV=development POSTGRESQL_DATABASE=ai4cod_production rails db:drop db:create db:migrate db:seed
