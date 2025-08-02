#!/bin/sh

set -e

RAILS_ENV=development POSTGRESQL_DATABASE=tmp rails db:environment:set || echo

RAILS_ENV=development POSTGRESQL_DATABASE=tmp rails db:drop db:create db:migrate
