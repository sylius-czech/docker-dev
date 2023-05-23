#!/usr/bin/env bash

PHP_TAG='docker-registry.praguebest.cz:5000/sylius-plugin-dev-php:8.1'
docker build --pull --target sylius-plugin-php --tag "$PHP_TAG" . && docker push "$PHP_TAG"

NGINX_TAG='docker-registry.praguebest.cz:5000/sylius-plugin-dev-nginx:1.24'
docker build --pull --target sylius-plugin-nginx --tag "$NGINX_TAG" . && docker push "$NGINX_TAG"
