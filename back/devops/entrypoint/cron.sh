#!/bin/sh

set -e

whenever --clear-crontab
whenever --update-crontab
crontab -l
sudo service cron start
sudo service cron status
