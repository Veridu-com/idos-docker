# idOS-Docker

This project creates a complete infrastructure to run idOS on docker containers.

## How to start

1. Clone this repository
2. Enter `idos-docker` folder
3. Clone [idos-api](https://github.com/veridu/idos-api)
4. Clone [idos-cra-handler](https://github.com/veridu/idos-cra-handler)
5. Clone [idos-email-handler](https://github.com/veridu/idos-email-handler)
6. Clone [idos-feature-handler](https://github.com/veridu/idos-feature-handler)
7. Clone [idos-manager](https://github.com/veridu/idos-manager)
8. Clone [idos-metrics](https://github.com/veridu/idos-metrics)
9. Clone [morpheus](https://github.com/veridu/morpheus)
10. Clone [idos-queue](https://github.com/veridu/idos-queue)
11. Clone [idos-scrape-handler](https://github.com/veridu/idos-scrape-handler)
12. Clone [idos-sms-handler](https://github.com/veridu/idos-sms-handler)
13. Clone [idos-watchdog](https://github.com/veridu/idos-watchdog)
14. Build [containers/ubuntu](containers/ubuntu)
15. Build [containers/gearman](containers/gearman)
16. Build [containers/nginx-php-fpm](containers/nginx-php-fpm)
17. Build [containers/php-daemon](containers/php-daemon)
18. Build [containers/spring](containers/spring)
19. Initiate the docker-compose
20. Test API status on `http://127.0.0.1:8000/1.0/`
