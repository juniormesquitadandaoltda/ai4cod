#!/bin/sh

set -e

. devops/compose/.env

if test -f devops/tmp/app.tar; then
  ./devops/compose/exec.sh app sudo tar -xf devops/tmp/app.tar -C /usr/local --strip 2
fi

ls -sh devops/tmp
