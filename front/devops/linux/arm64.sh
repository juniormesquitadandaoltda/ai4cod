#!/bin/sh

set -e

CURRENT_PLATFORM=$(uname -m)
([ "${CURRENT_PLATFORM}" = "arm64" ] || [ "${CURRENT_PLATFORM}" = "aarch64" ]) && echo 'Platform is a arm64' || (echo "Platform ${CURRENT_PLATFORM} is invalid" && exit 1)
