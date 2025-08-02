#!/bin/sh

set -e

npm run format:fix &&
  npm run format:check

npm run lint
