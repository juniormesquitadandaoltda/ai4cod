#!/bin/sh

set -e

. devops/compose/.env

if ! test -f devops/tmp/image.tar.gz; then
  docker save build-app | gzip > devops/tmp/image.tar.gz
fi

ls -sh devops/tmp
