#!/bin/bash


# update
sudo apt-get update

# package
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    htop \
    iftop \
    python-simplejson \
    software-properties-common

# registry
sudo mkdir /etc/docker/
echo '{ "insecure-registries":["registry.churrops.com"] }' | sudo tee /etc/docker/daemon.json
