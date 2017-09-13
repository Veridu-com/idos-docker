#!/bin/bash

set -exo pipefail

if ps ax | grep php | grep -v grep | grep -v watchdog > /dev/null; then
    exit 0
fi

exit 1
