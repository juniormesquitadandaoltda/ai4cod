#!/bin/sh

set -e

INSTANCE_ID=$(wget -q -O - 'http://169.254.169.254/latest/meta-data/instance-id') &&
  aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id eipalloc-0ea37fe3a63958586 #--no-allow-reassociation
