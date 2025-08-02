#!/bin/sh

set -e

cat /etc/hosts | grep dockerhost
echo > /dev/tcp/dockerhost/4004 && echo "Front is running."
echo > /dev/tcp/postgresql/5432 && echo "PostgreSQL is running."
echo > /dev/tcp/redis/6379 && echo "Redis is running."
env
