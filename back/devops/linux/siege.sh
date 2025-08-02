#!/bin/sh

set -e

docker build --file ./devops/linux/Dockerfile.siege --tag siege .

docker run --rm -it siege siege -c 100 -t 255s -b -v --no-parser --content-type "application/json" 'https://ai4cod-286022308.us-east-1.elb.amazonaws.com/data/public/notificators/token/notifications POST {}'
