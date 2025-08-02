#!/bin/sh

set -e

test -f /run/nginx.pid && ./devops/nginx/stop.sh || true
sudo rm -rf /run/nginx.pid
./devops/nginx/ssl.sh
./devops/nginx/start.sh

SERVER_PID=tmp/pids/server.pid
test -f $SERVER_PID && sudo kill -9 $(cat $SERVER_PID) || true
sudo rm -rf $SERVER_PID
sudo rm -rf log/*.log
rm -rf tmp/letter_opener

RAILS_ENV=development POSTGRESQL_DATABASE=ai4cod_sanbox rails s
