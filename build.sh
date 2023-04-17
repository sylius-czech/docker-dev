#!/usr/bin/env bash

docker build --pull --target sylius-plugin-php --tag jaroslavtyc/praguebest-sylius-plugin-dev-php:8.0 . && docker push jaroslavtyc/praguebest-sylius-plugin-dev-php:8.0
docker build --pull --target sylius-plugin-nginx --tag jaroslavtyc/praguebest-sylius-plugin-dev-nginx:1.24 . && docker push jaroslavtyc/praguebest-sylius-plugin-dev-nginx:1.24
