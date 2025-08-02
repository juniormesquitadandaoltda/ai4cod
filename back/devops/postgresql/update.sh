#!/bin/sh

set -e

rails db:create &&
  ./devops/postgresql/create_user.sh && \
  ./devops/postgresql/grant_reading.sh && \
  rails db:migrate && \
  rails db:seed && \
  ./devops/postgresql/grant_writing.sh
