#!/usr/bin/env bash
set -e

# set current host UID to Docker user www-data to keep same ownership, also change user to www-data on login to terminal
bash /usr/local/bin/docker-change-user-id node

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- node "$@"
fi

if [ "$1" = 'node' ] || [ "$1" = 'yarn' ]; then
  sudo -u node yarn install

  echo >&2 "Waiting for PHP to be ready..."
  until nc -z "$PHP_HOST" "$PHP_PORT"; do
    sleep 1
  done
  echo "...PHP is ready"

  if [ "$APP_ENV" = 'dev' ]; then
    sudo -u node yarn build
  fi
fi

exec sudo -u node "$@"
