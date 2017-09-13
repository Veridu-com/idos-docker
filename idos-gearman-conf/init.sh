#!/bin/bash

set -exo pipefail

function finish {
    kill -9 `pidof gearmand`
}

trap finish SIGTERM SIGKILL

if [ -z "${NUM_RETRIES}" ]; then
    NUM_RETRIES=3
fi

if [ -z "${LOG_FILE}" ]; then
    LOG_FILE='/dev/stdout'
fi

if [ -z "${NUM_THREADS}" ]; then
    NUM_THREADS=4
fi

if [ -z "${NUM_WAKEUP}" ]; then
    NUM_WAKEUP=1
fi

PARAMS="--job-retries=${NUM_RETRIES} \
    --log-file=${LOG_FILE} \
    --port=4730 \
    --round-robin \
    --threads=${NUM_THREADS} \
    --verbose=INFO \
    --worker-wakeup=${NUM_WAKEUP}"

if [ ! -z "${MEMCACHE_HOST}" ]; then
    PARAMS="$PARAMS --queue-type=libmemcached \
    --libmemcached-servers=${MEMCACHE_HOST}"
fi

echo "Starting gearman job server with params: ${PARAMS}"

exec /usr/local/sbin/gearmand $PARAMS
