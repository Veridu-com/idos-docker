#!/bin/bash

set -exo pipefail

mkdir -p /app/log && chmod 0777 /app/log

chmod 0777 /app/resources/emails/cache/

composer config -g github-oauth.github.com XXX

cd /app && composer install --optimize-autoloader --no-dev --prefer-dist --no-interaction
cd /watchdog && composer install --optimize-autoloader --no-dev --prefer-dist --no-interaction

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
