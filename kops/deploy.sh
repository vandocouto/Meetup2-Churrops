#!/usr/bin/env bash

# VARIABLES
ZONES_MASTER="us-east-1a,us-east-1b,us-east-1c"
ZONES="us-east-1d,us-east-1e,us-east-1f"

KOPS_STATE_STORE=s3://project-kube/kops
SSH=chaves/churrops.pem.pub
NAME=churrops.com
NET=weave

VPC_ID=$(./terraform/build.sh terraform/VPC/ output | grep -i vpc-* | cut -d" " -f3)
NETWORK_CIDR=10.0.0.0/21
AMI=$(cat kops/ami_kops.txt)

MASTERINST=3
NODEINST=3
MASTERINSTTYPE=t2.micro
NODEINSTTYPE=t2.micro
MASTEVOLSIZE=40
NODEVOLSIZE=50

KUBEVERSION=1.8.4
CLOUD=aws
DNS=private

# DEPLOY
kops create cluster \
    --associate-public-ip=true \
    --image=$AMI \
    --dns=$DNS \
    --master-count=$MASTERINST \
    --cloud=$CLOUD \
    --state=$KOPS_STATE_STORE \
    --cloud=aws \
    --kubernetes-version=$KUBEVERSION \
    --master-zones=$ZONES \
    --network-cidr=$NETWORK_CIDR \
    --networking=$NET \
    --topology=private \
    --node-count=$NODEINST \
    --zones=$ZONES \
    --node-size=$NODEINSTTYPE \
    --master-size=$MASTERINSTTYPE \
    --master-volume-size=$MASTEVOLSIZE \
    --node-volume-size=$NODEVOLSIZE \
    --vpc=$VPC_ID \
    --name=$NAME \
    --out ./kopsKube \
    --ssh-public-key=$SSH \
    --topology=public \
    --target=terraform
