#!/bin/sh

set -e

. devops/compose/.env

if test -f devops/tmp/volume.tar.gz; then
  ./devops/compose/exec.sh app sudo tar -xzf devops/tmp/volume.tar.gz -C /usr/local --strip 2
fi

ls -sh devops/tmp
