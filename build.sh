#!/usr/bin/env bash

docker build --pull --tag jaroslavtyc/praguebest-sylius-plugin-dev.8.0:latest . && docker push jaroslavtyc/praguebest-sylius-plugin-dev.8.0:latest
