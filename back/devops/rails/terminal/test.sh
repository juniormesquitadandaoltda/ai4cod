#!/bin/sh

set -e

RAILS_ENV=development POSTGRESQL_DATABASE=ai4cod_test rails c $@
