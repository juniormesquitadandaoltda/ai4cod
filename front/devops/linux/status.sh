#!/bin/sh

set -e

env
cat /etc/hosts | grep dockerhost

bash -c 'echo > /dev/tcp/dockerhost/3000 && echo "Back is running"'

./devops/linux/arm64.sh
