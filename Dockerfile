# Rebuild by calling `./build.sh`

# the different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/compose/compose-file/#target

ARG PHP_VERSION=8.2
ARG NGINX_VERSION=1.25
ARG ALPINE_VERSION=3.18
ARG COMPOSER_VERSION=latest
ARG PHP_EXTENSION_INSTALLER_VERSION=latest

FROM composer:${COMPOSER_VERSION} AS composer

FROM mlocati/php-extension-installer:${PHP_EXTENSION_INSTALLER_VERSION} AS php-extension-installer

FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION} AS sylius-plugin-php

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
        mysql-client \
        # to avoid ERROR 1045 (28000): Plugin caching_sha2_password could not be loaded: Error loading shared library /usr/lib/mariadb/plugin/caching_sha2_password.so: No such file or directory
        mariadb-connector-c \
        # shadow adds usermod and groupmod
        shadow \
        sudo \
        bash \
        yarn \
    ;

COPY --from=php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# default PHP image extensions
# ctype curl date dom fileinfo filter ftp hash iconv json libxml mbstring mysqlnd openssl pcre PDO pdo_sqlite Phar
# posix readline Reflection session SimpleXML sodium SPL sqlite3 standard tokenizer xml xmlreader xmlwriter zlib
RUN install-php-extensions apcu exif gd intl pdo_mysql opcache zip

RUN pecl channel-update pecl.php.net \
    && pecl install xdebug \
    ;

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY docker/php/test/php.ini        $PHP_INI_DIR/php.ini
COPY docker/php/test/opcache.ini    $PHP_INI_DIR/conf.d/opcache.ini
COPY docker/php/test/xdebug.ini     $PHP_INI_DIR/conf.d/xdebug.ini

COPY docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY docker/php/docker-change-user-id.sh /usr/local/bin/docker-change-user-id
RUN chmod +x /usr/local/bin/docker-entrypoint

COPY docker/php/.bash_aliases   /home/www-data/.bash_aliases
RUN chown -R www-data:www-data /home/www-data

# Composer is not allowed to be run under root / sudo / superuser by default. See docker/php/docker-entrypoint.sh how local user is used.
# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
# ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/usr/local/bin"

WORKDIR /srv/sylius

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

# taken from https://github.com/Sylius/Sylius-Standard/blob/1.12/Dockerfile
# note: there is no nginx:${NGINX_VERSION}-alpine3.16 version https://hub.docker.com/_/nginx/tags?page=1&name=alpine3
FROM nginx:${NGINX_VERSION}-alpine${ALPINE_VERSION} AS sylius-plugin-nginx

# taken from https://github.com/Sylius/Sylius-Standard/blob/1.12/docker/nginx/conf.d/default.conf
COPY docker/nginx/conf.d/default.conf /etc/nginx/conf.d/

# persistent / runtime deps
RUN apk add --no-cache \
        acl \
        linux-headers \
        # shadow adds usermod and groupmod
        shadow \
        sudo \
        bash \
    ;

# /docker-entrypoint.d is a "magic" dir with auto-included scripts on Nginx Docker image start
# see https://github.com/nginxinc/docker-nginx/blob/master/entrypoint/docker-entrypoint.sh
COPY docker/nginx/docker-entrypoint.d/docker-change-user-id.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/docker-change-user-id.sh

WORKDIR /srv/sylius
