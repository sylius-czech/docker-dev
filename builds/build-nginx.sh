#!/usr/bin/env bash

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
