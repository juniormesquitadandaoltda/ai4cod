#!/bin/sh

set -e

rm -rf devops/nginx/data

docker run --rm -it \
  --volume ${PWD}/devops/nginx:/home/user/ai4cod/back/devops/nginx \
  --workdir /home/user/ai4cod/back \
  ai4cod_back-app sudo mv -f /etc/nginx devops/nginx/data
