#!/bin/sh

set -e

mkdir -p /etc/nginx/ssl &&
  mkcert -key-file /etc/nginx/ssl/localhost.key -cert-file /etc/nginx/ssl/localhost.cert localhost &&
  mkcert -key-file /etc/nginx/ssl/localhost.key -cert-file /etc/nginx/ssl/localhost.cert -install
