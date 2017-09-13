FROM idos/ubuntu:latest

MAINTAINER Veridu Ltd <support@veridu.com>

RUN apt-get update && \
    apt-get -y install openjdk-8-jre openjdk-8-jdk --no-install-recommends --no-install-suggests

EXPOSE 8080

HEALTHCHECK CMD ["/bin/bash", "/healthcheck.sh"]

VOLUME ["/app", "/healthcheck.sh", "/init.sh"]
WORKDIR /app

CMD ["/init.sh"]
