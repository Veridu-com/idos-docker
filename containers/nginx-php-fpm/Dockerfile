FROM idos/ubuntu:latest

MAINTAINER Veridu Ltd <support@veridu.com>

# persistent / runtime deps
RUN apt-get update && apt-get install -y \
        autoconf \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkg-config \
        re2c \
        ca-certificates \
        curl \
        libedit2 \
        libsqlite3-0 \
        libxml2 \
        xz-utils \
    --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

ENV PHP_INI_DIR /usr/local/etc/php
RUN mkdir -p $PHP_INI_DIR/conf.d

# Apply stack smash protection to functions using local buffers and alloca()
# Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
# Enable optimization (-O2)
# Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
# Adds GNU HASH segments to generated executables (this is used if present, and is much faster than sysv hash; in this configuration, sysv hash is also generated)
# https://github.com/docker-library/php/issues/272
ENV CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV CPPFLAGS="$CFLAGS"
ENV LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

ENV PHP_EXTRA_BUILD_DEPS libpq-dev
ENV PHP_EXTRA_CONFIGURE_ARGS --with-pdo-pgsql --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --enable-opcache
ENV GPG_KEYS A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E

ENV PHP_VERSION 7.1.7
ENV PHP_FILENAME php-7.1.7.tar.xz
ENV PHP_SHA256 0d42089729be7b2bb0308cbe189c2782f9cb4b07078c8a235495be5874fff729

RUN set -xe \
    && cd /usr/src/ \
    && curl -fSL "https://php.net/get/$PHP_FILENAME/from/this/mirror" -o php.tar.xz \
    && echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c - \
    && curl -fSL "https://php.net/get/$PHP_FILENAME.asc/from/this/mirror" -o php.tar.xz.asc \
    && export GNUPGHOME="$(mktemp -d)" \
    && for key in $GPG_KEYS; do \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done \
    && gpg --batch --verify php.tar.xz.asc php.tar.xz \
    && rm -r "$GNUPGHOME"

COPY tools/docker-php-source /usr/local/bin/

# PHP Build & Install
RUN set -xe \
    && buildDeps=" \
        $PHP_EXTRA_BUILD_DEPS \
        libcurl4-openssl-dev \
        libedit-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
    " \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && docker-php-source extract \
    && cd /usr/src/php \
    && ./configure \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        $PHP_EXTRA_CONFIGURE_ARGS \
        --disable-cgi \
        --enable-mysqlnd \
        --enable-mbstring \
        --with-curl \
        --with-libedit \
        --with-openssl \
        --with-zlib \
    && make -j"$(nproc)" \
    && make install \
    && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
    && make clean \
    && cp php.ini-production $PHP_INI_DIR/php.ini

COPY tools/docker-php-ext-* /usr/local/bin/

# PHP Extensions (deps)
RUN apt-get update && \
    apt-get install -y libfreetype6-dev libjpeg-turbo8-dev libmcrypt-dev libpng12-dev libbz2-dev libxslt-dev libldap2-dev libcurl4-openssl-dev curl git subversion unzip wget --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# build and install gearman driver
RUN apt-get update && apt-get install -y git libgearman-dev && \
    git clone https://github.com/wcgallego/pecl-gearman.git -b gearman-2.0.3 && \
    cd pecl-gearman && phpize && ./configure && make && make install && \
    docker-php-ext-enable gearman && \
    cd .. && rm -rf pecl-gearman && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# install libsodium extension
# RUN git clone https://github.com/jedisct1/libsodium.git -b stable && \
#    cd libsodium && ./configure && make check && make install && cd .. && rm -rf libsodium && \
#    git clone https://github.com/jedisct1/libsodium-php.git && \
#    cd libsodium-php && git checkout tags/1.0.6 && phpize && ./configure && make && make install && \
#    docker-php-ext-enable libsodium && \
#    cd .. && rm -rf libsodium-php && \
#    apt-get autoremove -y && \
#    rm -rf /var/lib/apt/lists/*

# PHP Extensions (install)
RUN docker-php-ext-install -j$(nproc) mcrypt zip bz2 mbstring pcntl xsl && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    pecl update-channels && \
    pecl install mongodb-1.2.9 && \
    docker-php-ext-enable mongodb && \
    pecl install redis && \
    docker-php-ext-enable redis

# Cleanup
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps && \
    docker-php-source delete

# Execution Time
RUN echo "max_execution_time=60" > $PHP_INI_DIR/conf.d/execution-time.ini

# Memory Limit
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini

# POST Size Limit
RUN echo "post_max_size=100M" > $PHP_INI_DIR/conf.d/post-max-size.ini

# Upload File Size Limit
RUN echo "upload_max_filesize=100M" > $PHP_INI_DIR/conf.d/upload-max-filesize.ini

# Time Zone
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date-timezone.ini

# Tmp
RUN echo "upload_tmp_dir=/tmp" > $PHP_INI_DIR/conf.d/upload-tmp-dir.ini

# Hide PHP
RUN echo "expose_php=off" > $PHP_INI_DIR/conf.d/hide-php.ini

# OPCache
RUN docker-php-ext-enable opcache && \
    echo "opcache.enable=1" > $PHP_INI_DIR/conf.d/opcache.ini && \
    echo "opcache.memory_consumption=192" >> $PHP_INI_DIR/conf.d/opcache.ini && \
    echo "opcache.interned_strings_buffer=16" >> $PHP_INI_DIR/conf.d/opcache.ini && \
    echo "opcache.max_accelerated_files=4000" >> $PHP_INI_DIR/conf.d/opcache.ini && \
    echo "opcache.validate_timestamps=0" >> $PHP_INI_DIR/conf.d/opcache.ini && \
    echo "opcache.fast_shutdown=0" >> $PHP_INI_DIR/conf.d/opcache.ini && \
    echo "opcache.enable_cli=1" >> $PHP_INI_DIR/conf.d/opcache.ini && \
    echo "opcache.use_cwd=1" >> $PHP_INI_DIR/conf.d/opcache.ini && \
    echo "opcache.save_comments=0" >> $PHP_INI_DIR/conf.d/opcache.ini

# Allow Composer to be run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# Install Composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer && \
    curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig && \
    php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"
RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer && \
    rm -rf /tmp/composer-setup.php

# install mainline nginx
RUN wget -qO - http://nginx.org/keys/nginx_signing.key | apt-key add - \
    && echo "deb http://nginx.org/packages/mainline/ubuntu/ xenial nginx" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
                        ca-certificates \
                        nginx \
                        gettext-base \
    && rm -rf /var/lib/apt/lists/*

RUN rm /etc/nginx/conf.d/default.conf

# install supervisord:
RUN apt-get update && apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
RUN rm -f /usr/local/etc/php-fpm.conf && \
    rm -f /usr/local/etc/php-fpm.d/pool.conf && \
    rm -f /etc/nginx/nginx.conf && \
    rm -f /etc/nginx/conf.d/server.conf && \
    rm -f /etc/supervisor/conf.d/process.conf && \
    rm -f /etc/supervisor/supervisord.conf

HEALTHCHECK CMD ["/bin/bash", "/healthcheck.sh"]

# Set up the application directory.
VOLUME ["/app", "/etc/nginx/conf.d/server.conf", "/etc/nginx/nginx.conf", "/etc/supervisor/conf.d/process.conf", "/etc/supervisor/supervisord.conf", "/healthcheck.sh", "/init.sh", "/usr/local/etc/php-fpm.conf", "/usr/local/etc/php-fpm.d/pool.conf"]
WORKDIR /app

# Set up the command arguments.
CMD ["/init.sh"]
