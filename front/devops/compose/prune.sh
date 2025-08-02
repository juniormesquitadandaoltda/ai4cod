#!/bin/sh

set -e

# https://depot.dev/blog/docker-clear-cache
docker system prune --volumes -af
