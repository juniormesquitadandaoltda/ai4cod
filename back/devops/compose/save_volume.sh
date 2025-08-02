#!/bin/sh

set -e

. devops/compose/.env

if ! test -f devops/tmp/volume.tar.gz; then
  ./devops/compose/exec.sh app tar -czf devops/tmp/volume.tar.gz /usr/local
fi

ls -sh devops/tmp
