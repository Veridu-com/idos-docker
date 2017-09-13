# idOS Gearman - Docker

This repository is dedicated to run idOS on Docker.

***

## Volumes

- `/init.sh`

***

## Environment Variables

Variable name | Format  | Description
--------------|---------|------------
NUM_RETRIES   | integer | Number of retry for a failed job (default=3)
LOG_FILE      | string  | Path to log file (default=/dev/stdout)
NUM_THREADS   | integer | Number of threads to use (default=4)
NUM_WAKEUP    | integer | Number of workers to wake up on job receive (default=1)
MEMCACHE_HOST | string  | IP address for memcache server for persistent queue (optional)

***

## Log files

* gearman
  - $LOG_FILE or /dev/stdout
