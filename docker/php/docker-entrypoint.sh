#!/usr/bin/env bash
set -e # stop execution instantly as a query exits while having a non-zero status, useful when you need to know the error location in the running code

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

CURRENT_SCRIPT_FILE=$( realpath "${BASH_SOURCE[0]}" )

# Set UID of user www-data on guest (inside Docker) to match the UID of the user on the host machine
# `stat -c "%u" $1` gives user(owner) of this file (expected a file inside current Docker container)
usermod --uid $(stat -c "%u" "$CURRENT_SCRIPT_FILE") www-data
# Set GID of group www-data on guest to match the GID of the users primary group on the host machine
groupmod --gid $(stat -c "%g" $CURRENT_SCRIPT_FILE) www-data

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
