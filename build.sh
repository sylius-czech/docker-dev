#!/usr/bin/env bash

# PHP
PHP_VERSION=$(grep -oP 'ARG PHP_VERSION=\K[0-9]+[.][0-9]+' Dockerfile)
PHP_TAG="docker-registry.praguebest.cz:5000/sylius-plugin-dev-php:${PHP_VERSION}"
docker build --pull --target sylius-plugin-php --tag "$PHP_TAG" .
(docker run "$PHP_TAG" sh -c 'echo IT works even with PHP!' && docker push "$PHP_TAG") || (echo 'PHP image is broken' && exit 1)

# NGINX
NGINX_VERSION=$(grep -oP 'ARG NGINX_VERSION=\K[0-9]+[.][0-9]+' Dockerfile)

NGINX_BASE_NAME="docker-registry.praguebest.cz:5000/sylius-app-dev-nginx"
NGINX_TAG="${NGINX_BASE_NAME}:${NGINX_VERSION}"
NGINX_LATEST_TAG="${NGINX_BASE_NAME}:latest"
docker build --pull --target sylius-app-nginx --tag "$NGINX_TAG" --tag "$NGINX_LATEST_TAG" .
(docker run "$NGINX_TAG" sh -c 'echo IT works even with Nginx for app!' && docker push --all-tags "${NGINX_BASE_NAME}") || (echo 'Nginx image for app is broken' && exit 1)

NGINX_BASE_NAME="docker-registry.praguebest.cz:5000/sylius-plugin-dev-nginx"
NGINX_TAG="${NGINX_BASE_NAME}:${NGINX_VERSION}"
NGINX_LATEST_TAG="${NGINX_BASE_NAME}:latest"
docker build --pull --target sylius-plugin-nginx --tag "$NGINX_TAG" --tag "$NGINX_LATEST_TAG" .
(docker run "$NGINX_TAG" sh -c 'echo IT works even with Nginx for plugin!' && docker push --all-tags "${NGINX_BASE_NAME}") || (echo 'Nginx image for plugin is broken' && exit 1)

# NODE.JS
NODE_VERSION=$(grep -oP 'ARG NODE_VERSION=\K[0-9]+([.][0-9]+)?' Dockerfile)
NODE_BASE_NAME="docker-registry.praguebest.cz:5000/sylius-plugin-dev-node"
NODE_TAG="${NODE_BASE_NAME}:${NODE_VERSION}"
NODE_LATEST_TAG="${NODE_BASE_NAME}:latest"
docker build --pull --target sylius-plugin-node --tag "$NODE_TAG" --tag "$NODE_LATEST_TAG" .
(docker run "$NODE_TAG" sh -c 'echo IT works even with Node.js!' && docker push --all-tags "${NODE_BASE_NAME}") || (echo 'Node.js image is broken' && exit 1)
