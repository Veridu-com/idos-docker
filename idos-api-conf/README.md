# idOS API - Docker

This repository is dedicated to run idOS on Docker.

***

## Volumes

* /app
* /etc/logrotate.d/logrotate.conf (inherited)
* /etc/nginx/conf.d/server.conf
* /etc/nginx/nginx.conf
* /etc/supervisor/conf.d/process.conf
* /etc/supervisor/supervisord.conf
* /init.sh
* /usr/local/etc/php-fpm.conf
* /usr/local/etc/php-fpm.d/pool.conf

***

## Environment Variables

Variable name        | Format  | Description
---------------------|---------|------------
IDOS_VERSION         | string  | API version
IDOS_DEBUG           | integer | Debug mode (1 = on; 0 = off)
IDOS_TRUSTED_PROXIES | string  | Comma separated list of IP addresses for trusted proxies
IDOS_LOG_FILE        | string  | Path to log file
IDOS_SQL_DRIVER      | string  | SQL driver (pgsql)
IDOS_SQL_HOST        | string  | SQL server host
IDOS_SQL_PORT        | integer | SQL server port
IDOS_SQL_NAME        | string  | SQL database name
IDOS_SQL_USER        | string  | SQL username
IDOS_SQL_PASS        | string  | SQL password
IDOS_NOSQL_DRIVER    | string  | NOSQL driver (mongodb)
IDOS_NOSQL_HOST      | string  | NOSQL server host
IDOS_NOSQL_PORT      | integer | NOSQL server port
IDOS_GEARMAN_SERVERS | string  | Json encoded array of IP addresses
IDOS_OPTIMUS_PRIME   | integer | Optimus Prime Value
IDOS_OPTIMUS_INVERSE | integer | Optimus Inverse Value
IDOS_OPTIMUS_RANDOM  | integer | Optimus Random Value
IDOS_SECURE_KEY      | string  | Key used for encrypting data

***

## Log files

+ nginx
    * /var/log/nginx/access.log
    * /var/log/nginx/error.log

+ php-fpm
    * /var/log/php-fpm.log
    * /var/log/slow-php-fpm.log

+ supervisord
    * /var/log/supervisor/supervisord.log

+ application
    * `$IDOS_LOG_FILE` or /app/log/api.log
