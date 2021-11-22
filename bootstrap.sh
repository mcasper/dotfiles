#!/bin/bash

set -eou pipefail

PLATFORM=$(uname)

if [ "${PLATFORM}" = "Linux" ]; then
  bash bootstrap-linux.sh
elif [ "${PLATFORM}" = "Darwin" ]; then
  bash bootstrap-mac.sh
else
  echo "I don't know how to bootstrap platform ${PLATFORM}"
  exit 1
fi
