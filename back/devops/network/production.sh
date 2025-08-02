#!/bin/sh

set -e

echo "$(ip route | grep default | awk '{print $3}') dockerhost" | sudo tee -a /etc/hosts
bash -c 'echo > /dev/tcp/dockerhost/6379 && echo "Redis is running"'
