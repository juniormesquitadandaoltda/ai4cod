#!/bin/sh

set -e

RAILS_ENV=development POSTGRESQL_DATABASE=ai4cod_playground rails db:environment:set || echo

RAILS_ENV=development POSTGRESQL_DATABASE=ai4cod_playground rails db:drop db:create db:migrate db:seed
