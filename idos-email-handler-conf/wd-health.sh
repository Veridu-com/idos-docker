#!/bin/bash

set -exo pipefail

if [ ! -z "${WATCHDOG_DISABLED}" ] && [ "${WATCHDOG_DISABLED}" -eq "1" ]; then
    exit
fi

if [ -z "${WATCHDOG_LISTEN_PORT}" ]; then
    echo "WATCHDOG_LISTEN_PORT is not set, using default value!"
    WATCHDOG_LISTEN_PORT=35112
fi

PARAMS="${WATCHDOG_LISTEN_PORT}"

if [ ! -z "${WATCHDOG_LISTEN_IP}" ]; then
    PARAMS="-i ${WATCHDOG_LISTEN_IP} ${PARAMS}"
fi

if [ ! -z "${WATCHDOG_LOG_FILE}" ]; then
    PARAMS="-l ${WATCHDOG_LOG_FILE} ${PARAMS}"
fi

exec /watchdog/watchdog-cli.php check:health $PARAMS
