#!/usr/bin/env bash
set -e # stop execution instantly as a query exits while having a non-zero status, useful when you need to know the error location in the running code

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi

# set current host UID to Docker user www-data to keep same ownership, also change user to www-data on login to terminal
bash /usr/local/bin/docker-change-user-id www-data

exec docker-php-entrypoint "$@" # for input arguments represented by "$@" see CMD ["php-fpm"] at the end of Dockerfile
