#!/usr/bin/env bash
set -e # stop execution instantly as a query exits while having a non-zero status, useful when you need to know the error location in the running code

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi

# set current host UID to Docker user node to keep same ownership, also change user to node on login to terminal
bash /usr/local/bin/docker-change-user-id node

#docker-entrypoint.sh "$@" # for input arguments represented by "$@" see CMD ["node"] at the end of Dockerfile

tail -f /dev/null # just a little trick to do not exit running container without any job
