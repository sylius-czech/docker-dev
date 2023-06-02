#!/usr/bin/env bash

PHP_VERSION=$(grep -oP 'ARG PHP_VERSION=\K[0-9]+[.][0-9]+' Dockerfile)
PHP_TAG="docker-registry.praguebest.cz:5000/sylius-plugin-dev-php:${PHP_VERSION}"
docker build --pull --target sylius-plugin-php --tag "$PHP_TAG" .
(docker run "$PHP_TAG" sh -c 'echo IT works even with PHP!' && docker push "$PHP_TAG") || (echo 'PHP image is broken' && exit 1)

NGINX_VERSION=$(grep -oP 'ARG NGINX_VERSION=\K[0-9]+[.][0-9]+' Dockerfile)
NGINX_TAG="docker-registry.praguebest.cz:5000/sylius-plugin-dev-nginx:${NGINX_VERSION}"
docker build --pull --target sylius-plugin-nginx --tag "$NGINX_TAG" .
(docker run "$NGINX_TAG" sh -c 'echo IT works even with Nginx!' && docker push "$NGINX_TAG") || (echo 'Nginx image is broken' && exit 1)
