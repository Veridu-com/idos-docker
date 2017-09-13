# idOS Widget - Docker

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
    * `$IDOS_LOG_FILE` or /app/log/widget.log
