#!/bin/sh
set -e # stop execution instantly as a query exits while having a non-zero status, useful when you need to know the error location in the running code

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

# Set UID of user www-data on guest (inside Docker) to match the UID of the user on the host machine
# `stat -c "%u" $1` gives user(owner) of given parameter (expected a file inside current Docker container)
usermod -u $(stat -c "%u" $1) www-data
# Set GID of group www-data on guest to match the GID of the users primary group on the host machine
groupmod -g $(stat -c "%g" $1) www-data

# variable $UID is not empty and is not zero
if [ -n "${UID+x}" ] && [ "$UID" -ne 0 ]; then
  usermod --uid "$UID" www-data # allow to set UID manually from host
fi
# variable $GID is not empty and is not zero
if [ -n "${GID+x}" ] && [ "$GID" -ne 0 ]; then
  groupmod --gid "$GID" www-data # allow to set GID manually from host
fi

chgrp www-data /usr/local/bin/docker-entrypoint

# Allow user www-data to log in to use development tools
usermod --shell /bin/bash www-data

exec docker-php-entrypoint "$@"
