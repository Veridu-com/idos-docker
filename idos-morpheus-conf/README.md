# idOS Morpheus - Docker

This repository is dedicated to run idOS on Docker.

***

## Volumes

* /app
* /etc/logrotate.d/logrotate.conf (inherited)
* /init.sh

***

## Environment Variables

Variable name           | Format | Description
------------------------|--------|------------
SPRING_APPLICATION_JSON | string | Spring configuration (JSON formatted)

## Application Configuration Sample

```json
{
  "server": {
    "address": "127.0.0.1",
    "port": 8080
  },
  "logging": {
    "file": "morpheus-spring.log"
  },
  "morpheus": {
    "http": {
      "user": "***REMOVED***",
      "password": "***REMOVED***"
    },
    "handlerPrivateKey": "***REMOVED***",
    "handlerPublicKey": "***REMOVED***",
    "useSSL": true,
    "IDOS_DEBUG": 1,
    "IDOS_API_URL": "https://api.idos.io/1.0"
  },
  "aws": {
    "ACCESS_KEY": "***REMOVED***",
    "SECRET": "***REMOVED***"
  }
}
```
