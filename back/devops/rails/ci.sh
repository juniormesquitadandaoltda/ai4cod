#!/bin/sh

set -e


./devops/whenever/update.sh
./devops/whenever/clear.sh

rails runner 'Rails.application.eager_load!'
rails --tasks

./devops/rails/rubocop.sh
./devops/rails/reset/development.sh
CI=TRUE ./devops/rails/test.sh
