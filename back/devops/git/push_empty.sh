#!/bin/sh

set -e

git commit --allow-empty -m "${1}"
git push
