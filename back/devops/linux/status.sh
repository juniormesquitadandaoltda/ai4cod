#!/bin/sh

set -e

env
cat /etc/hosts | grep dockerhost

bash -c 'echo > /dev/tcp/dockerhost/4004 && echo "Front is running"'
bash -c 'echo > /dev/tcp/postgresql/5432 && echo "PostgreSQL is running"'
bash -c 'echo > /dev/tcp/redis/6379 && echo "Redis is running"'

./devops/linux/arm64.sh
