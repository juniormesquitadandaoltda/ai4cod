#!/bin/sh

set -e

SPEC_FILE_PATH=$(ruby -e "puts './$@'.gsub('back/', '')")

bash -c "LOG=\$([[ $SPEC_FILE_PATH =~ 'spec.rb:' ]] && echo 'TRUE') rspec $SPEC_FILE_PATH"
