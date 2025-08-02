#!/bin/sh

set -e

free -h
df -h
du -sh
docker system df
