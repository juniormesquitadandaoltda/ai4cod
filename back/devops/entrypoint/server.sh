#!/bin/sh

set -e

./devops/network/${RAILS_ENV}.sh

./devops/nginx/start.sh

rails s 1> /dev/null
