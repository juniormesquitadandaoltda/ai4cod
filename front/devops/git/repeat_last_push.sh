#!/bin/sh

set -e

git add ../
git commit --amend -m "$(git show -s --format=%s)"
git push -f
