#!/usr/bin/env bash
set -e # stop execution instantly as a query exits while having a non-zero status, useful when you need to know the error location in the running code

REQUIRED_USER=$1

CURRENT_UID=0
CURRENT_GID=0
# variable $GID is not empty and is not zero
if [ -n "${UID+x}" ] && [ "${UID}" -ne 0 ]; then
  CURRENT_UID=$UID # externally passed as an env variable
fi
# variable $GID is not empty and is not zero
if [ -n "${GID+x}" ] && [ "${GID}" -ne 0 ]; then
  CURRENT_GID=$GID # externally passed as an env variable
fi

CURRENT_SCRIPT_FILE=$(realpath "${BASH_SOURCE[0]}")
DIR_SHARED_FROM_HOST=/usr/local/sylius-plugin-dev

# Set CURRENT_UID of user on guest (inside Docker) to match the CURRENT_UID of the user on the host machine
# `stat -c "%u" $1` gives user(owner) of this file (expected a file inside current Docker container)
if [ -z "${CURRENT_UID}" ] || [ "${CURRENT_UID}" -eq 0 ]; then
  CURRENT_SCRIPT_UID=$(stat -c "%u" "$CURRENT_SCRIPT_FILE")
  if [ "$CURRENT_SCRIPT_UID" -gt 0 ]; then
    CURRENT_UID=$CURRENT_SCRIPT_UID
  elif [ -f "$DIR_SHARED_FROM_HOST" ]; then
    SHARED_DIR_UID=$(stat -c "%u" "$DIR_SHARED_FROM_HOST")
    if [ "$SHARED_DIR_UID" -gt 0 ]; then
      CURRENT_UID=$SHARED_DIR_UID
    fi
  fi
fi

# Set GID of group on guest to match the GID of the users primary group on the host machine
if [ -z "${CURRENT_GID}" ] || [ "${CURRENT_GID}" -eq 0 ]; then
  CURRENT_SCRIPT_GID=$(stat -c "%g" "$CURRENT_SCRIPT_FILE")
  if [ "$CURRENT_SCRIPT_GID" -gt 0 ]; then
    CURRENT_GID=$CURRENT_SCRIPT_GID
  elif [ -f "$DIR_SHARED_FROM_HOST" ]; then
    SHARED_DIR_GID=$(stat -c "%g" "$DIR_SHARED_FROM_HOST")
    if [ "$SHARED_DIR_GID" -gt 0 ]; then
      CURRENT_GID=$SHARED_DIR_GID
    fi
  fi
fi

if [ -z "${CURRENT_UID}" ] || [ "${CURRENT_UID}" -eq 0 ]; then
  CURRENT_UID=1000
fi
if [ -z "${CURRENT_GID}" ] || [ "${CURRENT_GID}" -eq 0 ]; then
  CURRENT_GID=1000
fi

usermod --uid "${CURRENT_UID}" "${REQUIRED_USER}"  # allow to set UID manually from host
groupmod --gid "${CURRENT_GID}" "${REQUIRED_USER}" # allow to set GID manually from host

# Allow user to log in to use development tools
usermod --shell /bin/bash "${REQUIRED_USER}"

# has to --preserve-env to have env variables from docker-compose.yml available for switched user
echo -e echo "Switching to user ${REQUIRED_USER}\n" \
  sudo --preserve-env su "${REQUIRED_USER}\n" \
  echo You are now "'$(whoami) $(id)'" \
  >/root/.bashrc

echo -e 'export PATH="/usr/local/bin:$PATH"
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
' \
  >/home/www-data/.bashrc

chown -R www-data:www-data /home/www-data
