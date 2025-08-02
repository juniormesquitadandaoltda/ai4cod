#!/bin/sh

set -e

# "production": "http-server dist --proxy http://dockerhost:3000/api --proxy-options.autoRewrite true",
npm run production
