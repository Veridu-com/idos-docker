#!/bin/bash

set -exo pipefail

curl -f http://127.0.0.1:8080/status || exit 1
