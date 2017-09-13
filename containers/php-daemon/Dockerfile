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
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-sockets --with-pdo-pgsql --enable-maintainer-zts --enable-soap
ENV GPG_KEYS 1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3

ENV PHP_VERSION 7.0.21
ENV PHP_FILENAME php-7.0.21.tar.xz
ENV PHP_SHA256 6713fe3024365d661593235b525235045ef81f18d0043654658c9de1bcb8b9e3

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

# Gearman Extension
RUN apt-get update && apt-get install -y git libgearman-dev && \
    git clone https://github.com/wcgallego/pecl-gearman.git -b gearman-2.0.3 && \
    cd pecl-gearman && phpize && ./configure && make && make install && \
    docker-php-ext-enable gearman && \
    cd .. && rm -rf pecl-gearman && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# PHP Extensions (deps)
RUN apt-get update && \
    apt-get install -y libfreetype6-dev libjpeg-turbo8-dev libmcrypt-dev libpng12-dev libbz2-dev libxslt-dev libldap2-dev libcurl4-openssl-dev libgmp-dev curl git subversion unzip wget --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# PHP Extensions (install)
RUN docker-php-ext-install -j$(nproc) mcrypt zip bz2 mbstring pcntl xsl gmp && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    pecl update-channels && \
    pecl install pthreads && \
    docker-php-ext-enable pthreads

# Cleanup
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps && \
    docker-php-source delete

# Memory Limit
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini

# Time Zone
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

# Allow Composer to be run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# Install Composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer && \
    curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig && \
    php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"
RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer && \
    rm -rf /tmp/composer-setup.php

# install supervisord:
RUN apt-get update && apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
RUN rm -f /etc/supervisor/conf.d/process.conf && \
    rm -f /etc/supervisor/supervisord.conf

# add a worker user, so we don't run the whole thing as root
RUN useradd -d /home/worker -m worker -s /bin/bash


HEALTHCHECK CMD ["/bin/bash", "/healthcheck.sh"]

# Set up the application directory.
VOLUME ["/app","/etc/supervisor/conf.d/process.conf", "/etc/supervisor/supervisord.conf", "/healthcheck.sh", "/init.sh", "/watchdog", "/daemon.sh", "/wd-elb.sh", "/wd-health.sh"]
WORKDIR /app

# Set up the command arguments.
CMD ["/init.sh"]
