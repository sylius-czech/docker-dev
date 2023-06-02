#!/usr/bin/env bash

NODE_VERSION=$(grep -oP 'ARG NODE_VERSION=\K[0-9]+[.][0-9]+' Dockerfile)

NODE_TAG="docker-registry.praguebest.cz:5000/sylius-storefrontx-dev-node:${NODE_VERSION}"

docker build --pull --target sylius-storefrontx-dev --tag "$NODE_TAG" .

(docker run "$NODE_TAG" sh -c 'echo "IT works!"' && docker push "$NODE_TAG") || (echo 'DOCKER IMAGE IS BROKEN' && exit 1)
