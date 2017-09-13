#!/bin/bash

set -exo pipefail

function finish {
    kill -9 `pidof java`
}

trap finish SIGTERM SIGKILL

if [ -z "${JAVA_XMS}" ]; then
    JAVA_XMS=5G
fi

if [ -z "${JAVA_XMX}" ]; then
    JAVA_XMX=5G
fi

if [ -z "${JAVA_METASPACE}" ]; then
    JAVA_METASPACE=1G
fi

if [ -z "${JAVA_MAX_METASPACE}" ]; then
    JAVA_MAX_METASPACE=1G
fi

exec java -Xms"${JAVA_XMS}" -Xmx"${JAVA_XMX}" -XX:MetaspaceSize="${JAVA_METASPACE}" -XX:MaxMetaspaceSize="${JAVA_MAX_METASPACE}" -Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/./urandom -jar /app/app.jar
