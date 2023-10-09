#!/usr/bin/env bash

NODE_VERSION=$(grep -oP 'ARG NODE_VERSION=\K[0-9]+([.][0-9]+)?' Dockerfile)
NODE_BASE_NAME="docker-registry.praguebest.cz:5000/sylius-plugin-dev-node"
NODE_TAG="${NODE_BASE_NAME}:${NODE_VERSION}"
NODE_LATEST_TAG="${NODE_BASE_NAME}:latest"
docker build --pull --target sylius-plugin-node --tag "$NODE_TAG" --tag "$NODE_LATEST_TAG" .
(docker run "$NODE_TAG" sh -c 'echo IT works even with Node.js!' && docker push --all-tags "${NODE_BASE_NAME}") || (echo 'Node.js image is broken' && exit 1)
