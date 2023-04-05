#!/usr/bin/env bash
set -e # stop execution instantly as a query exits while having a non-zero status, useful when you need to know the error location in the running code

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

if [ "$(id -u)" -eq 0 ]; then # running as root, lets try to switch to current host user
  bash /usr/local/bin/docker-change-user-id www-data
  sudo su www-data
fi

exec docker-php-entrypoint "$@" # for input arguments represented by "$@" see CMD ["php-fpm"] at the end of Dockerfile
