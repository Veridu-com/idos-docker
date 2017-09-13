# idOS Queue - Docker

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
IDOS_GEARMAN_SERVERS | string  | Json encoded array of IP addresses

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
    * `$IDOS_LOG_FILE` or /app/log/queue.log
