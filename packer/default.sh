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

# install docker 17.09 ce
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce

# install compose
 sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

# install kubernetes
sudo apt-get update
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# ctop
sudo wget https://github.com/bcicen/ctop/releases/download/v0.6.0/ctop-0.6.0-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop
