#!/bin/sh

set -e

docker run --rm -it \
  --volume=${PWD}/devops/linux:/home/node/ai4cod/back/devops/linux  \
  --workdir=/home/node \
  --entrypoint='' \
  --add-host=dockerhost:host-gateway \
  artilleryio/artillery:latest artillery/bin/run run -e $1 ai4cod/back/devops/linux/artillery.yml
