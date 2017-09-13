FROM idos/ubuntu:latest

MAINTAINER Veridu Ltd <support@veridu.com>

# install dependencies and compile gearman
RUN apt-get update && \
    apt-get build-dep -y gearman-job-server --no-install-recommends --no-install-suggests && \
    apt-get -y install wget gperf
RUN wget https://github.com/gearman/gearmand/releases/download/1.1.16/gearmand-1.1.16.tar.gz && \
    tar -xzvf gearmand-1.1.16.tar.gz && \
    cd gearmand-1.1.16 && \
    ./configure --disable-libdrizzle --disable-libpq --disable-libtokyocabinet --disable-hiredis --without-mysql --without-sqlite3 --enable-libmemcached && make && make install && ldconfig
RUN rm -rf gearmand-1.1.16* && \
    apt-get autoremove && \
    rm -r /var/lib/apt/lists/*


HEALTHCHECK CMD ["/bin/bash", "/healthcheck.sh"]

EXPOSE 4730
VOLUME ["/healthcheck.sh", "/init.sh"]

CMD ["/init.sh"]
