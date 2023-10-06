# Rebuild by calling `./build.sh`

# test images works

# the different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/compose/compose-file/#target

ARG NODE_VERSION=18.16
ARG ALPINE_VERSION=3.18
ARG COMPOSER_VERSION=latest
ARG PHP_EXTENSION_INSTALLER_VERSION=latest

FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS sylius-storefrontx-dev

# persistent / runtime deps
RUN apk add --no-cache \
        acl \
        file \
        gettext \
        unzip \
        git \
        autoconf \
        build-base \
        linux-headers \
        # shadow adds usermod and groupmod
        shadow \
        sudo \
        bash \
        yarn \
    ;


COPY docker/node/docker-pb-entrypoint.sh /usr/local/bin/docker-pb-entrypoint
COPY docker/node/docker-change-user-id.sh /usr/local/bin/docker-change-user-id

RUN chmod +x /usr/local/bin/docker-pb-entrypoint

ENV PATH="${PATH}:/usr/local/bin"

WORKDIR /srv/sylius

# build for test
ENV APP_ENV=test

ENTRYPOINT ["docker-pb-entrypoint"]
CMD ["node"]

WORKDIR /srv/sylius
