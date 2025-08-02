#!/bin/sh

set -e

# ./devops/stress_memory.sh 50
while true;do < /dev/zero head -c $1m | tail; done;
