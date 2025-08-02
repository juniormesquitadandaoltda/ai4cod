#!/bin/sh

set -e

git branch -D $(git branch | grep -v 'main\|develop\|playground|sandbox\|production')
git pull --all
