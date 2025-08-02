#!/bin/sh

set -e

. ./devops/ecs/.env

ssh -o StrictHostKeyChecking=accept-new -i devops/tmp/keypairs/production.pem ec2-user@$HOST_PRODUCTION 'ec2-metadata --public-hostname' ||
  ssh-keygen -f ~/.ssh/known_hosts -R $HOST_PRODUCTION

echo '*** docker exec -it $(docker ps --filter="name=worker" --format="{{.Names}}") bash ***'
echo '*** rails c *** '

ssh -o StrictHostKeyChecking=accept-new -i devops/tmp/keypairs/production.pem ec2-user@$HOST_PRODUCTION
