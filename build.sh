#!/usr/bin/env bash

PHP_VERSION=$(grep -oP 'ARG PHP_VERSION=\K[0-9]+[.][0-9]+' Dockerfile)
PHP_TAG="docker-registry.praguebest.cz:5000/sylius-plugin-dev-php:${PHP_VERSION}"
docker build --pull --target sylius-plugin-php --tag "$PHP_TAG" .
(docker run "$PHP_TAG" sh -c 'echo IT works even with PHP!' && docker push "$PHP_TAG") || (echo 'PHP image is broken' && exit 1)

NGINX_VERSION=$(grep -oP 'ARG NGINX_VERSION=\K[0-9]+[.][0-9]+' Dockerfile)
NGINX_BASE_NAME="docker-registry.praguebest.cz:5000/sylius-plugin-dev-nginx"
NGINX_TAG="${NGINX_BASE_NAME}:${NGINX_VERSION}"
NGINX_LATEST_TAG="${NGINX_BASE_NAME}:latest"
docker build --pull --target sylius-plugin-nginx --tag "$NGINX_TAG" --tag "$NGINX_LATEST_TAG" .
(docker run "$NGINX_TAG" sh -c 'echo IT works even with Nginx!' && docker push --all-tags "${NGINX_BASE_NAME}") || (echo 'Nginx image is broken' && exit 1)
