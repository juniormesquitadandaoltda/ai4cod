#!/bin/sh

set -e

whenever --clear-crontab

crontab -l
