#!/usr/bin/env bash

PHP_VERSION=$(grep -oP 'ARG PHP_VERSION=\K[0-9]+[.][0-9]+' Dockerfile)
PHP_BASE_NAMES=(
  "docker-registry.praguebest.cz:5000/sylius-app-dev-php"
  "docker-registry.praguebest.cz:5000/sylius-plugin-dev-php"
)
for PHP_BASE_NAME in ${PHP_BASE_NAMES[*]}; do
  PHP_TAG="${PHP_BASE_NAME}:${PHP_VERSION}"
  docker build --pull --target sylius-plugin-php --tag "${PHP_TAG}" .
  (docker run "${PHP_TAG}" sh -c "echo IT works even with PHP ${PHP_VERSION}!" && docker push "${PHP_TAG}") || (echo "PHP image ${PHP_VERSION} is broken" && exit 1)
done
