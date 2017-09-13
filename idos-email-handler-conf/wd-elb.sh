#!/bin/bash

set -exo pipefail

if [ ! -z "${WATCHDOG_DISABLED}" ] && [ "${WATCHDOG_DISABLED}" -eq "1" ]; then
    exit
fi

if [ -z "${ENVIRONMENT_EB}" ]; then
    echo "ENVIRONMENT_EB is not set!"
    exit
fi

if [ -z "${IDOS_GEARMAN_SERVERS}" ]; then
    echo "IDOS_GEARMAN_SERVERS is not set!"
    exit
fi

if [ -z "${WATCHDOG_ELB_LIST}" ]; then
    echo "WATCHDOG_ELB_LIST is not set, using default values!"
    WATCHDOG_ELB_LIST='awseb-ID1 awseb-ID2'
fi

PARAMS="${ENVIRONMENT_EB} ${IDOS_GEARMAN_SERVERS} ${WATCHDOG_ELB_LIST}"

if [ ! -z "${WATCHDOG_LOG_FILE}" ]; then
    PARAMS="-l ${WATCHDOG_LOG_FILE} ${PARAMS}"
fi

exec /watchdog/watchdog-cli.php check:elb $PARAMS
