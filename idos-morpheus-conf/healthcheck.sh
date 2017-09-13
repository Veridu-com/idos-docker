#!/bin/bash

set -exo pipefail

if ps ax | grep java | grep -v grep > /dev/null; then
    exit 0
fi

exit 1
