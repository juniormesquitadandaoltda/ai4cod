#!/bin/sh

set -e

./devops/network/${RAILS_ENV}.sh

./devops/eip/${RAILS_ENV}.sh &
./devops/entrypoint/cron.sh &

sidekiq 1> /dev/null
