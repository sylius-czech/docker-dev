#!/usr/bin/env bash

PHP_VERSION=$(grep -oP 'ARG PHP_VERSION=\K[0-9]+[.][0-9]+' Dockerfile)
PHP_TAG="docker-registry.praguebest.cz:5000/sylius-plugin-dev-php:${PHP_VERSION}"
docker build --pull --target sylius-plugin-php --tag "$PHP_TAG" .
(docker run "$PHP_TAG" sh -c 'echo IT works even with PHP!' && docker push "$PHP_TAG") || (echo 'PHP image is broken' && exit 1)
