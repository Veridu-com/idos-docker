#!/bin/bash

set -exo pipefail

if [ -z "${IDOS_GEARMAN_SERVERS}" ]; then
    echo "IDOS_GEARMAN_SERVERS is not set!"
    exit
fi

if [ -z "${IDOS_DAEMON_PARAMS}" ]; then
    echo "IDOS_DAEMON_PARAMS is not set, using default value!"
    IDOS_DAEMON_PARAMS='pubKey privKey cra'
fi

if [ -z "${IDOS_VERSION}" ]; then
    IDOS_VERSION='1.0'
fi

PARAMS="${IDOS_DAEMON_PARAMS} ${IDOS_GEARMAN_SERVERS}"

if [ ! -z "${IDOS_LOG_FILE}" ]; then
    PARAMS="-l ${IDOS_LOG_FILE} ${PARAMS}"
fi

if [ ! -z "${IDOS_DAEMON_HEALTH_CHECK}" ] && [ "${IDOS_DAEMON_HEALTH_CHECK}" -eq "1" ]; then
    PARAMS="-c ${PARAMS}"
fi

if [ ! -z "${IDOS_DEBUG}" ] && [ "${IDOS_DEBUG}" -eq "1" ]; then
    PARAMS="-d ${PARAMS}"
fi

exec /app/cra-cli.php cra:daemon $PARAMS
