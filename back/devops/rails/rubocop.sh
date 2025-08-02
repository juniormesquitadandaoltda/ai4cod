#!/bin/sh

set -e

brakeman \
  -A \
  --color \
  --skip-files app/filters/admin/application_filter.rb,app/filters/standard/application_filter.rb \
  --except ForceSSL \
  -o /dev/stdout \
  -o coverage/brakeman.html

rubocop -a
