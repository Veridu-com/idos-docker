FROM ubuntu:xenial

MAINTAINER Veridu Ltd <support@veridu.com>

# https://blog.packagecloud.io/eng/2017/02/21/set-environment-variable-save-thousands-of-system-calls/
ENV TZ=:/etc/localtime

# use ubuntu mirrors for apt to speed up the process
RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src mirror://mirrors.ubuntu.com/mirrors.txt xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse" >> /etc/apt/sources.list

# dist upgrade and basic dependencies
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y locales wget ca-certificates logrotate --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# make the "en_US.UTF-8" locale
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# installs dumb-init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 && \
    chmod +x /usr/local/bin/dumb-init

# Set up the command arguments.
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
