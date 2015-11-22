#!/bin/bash

apt-get update

apt-get install -y ca-certificates wget iptables vim

update-ca-certificates

cd /tmp

# Download the release file of Kubernetes 1.0.7
wget https://github.com/kubernetes/kubernetes/releases/download/v1.0.7/kubernetes.tar.gz

tar -xzvf kubernetes.tar.gz

tar -xzvf kubernetes/server/kubernetes-server-linux-amd64.tar.gz

# Install the executable binary of kubernetes
cp kubernetes/server/bin/hyperkube /usr/local/bin/
cp kubernetes/server/bin/kube-apiserver /usr/local/bin/
cp kubernetes/server/bin/kube-controller-manager /usr/local/bin/
cp kubernetes/server/bin/kube-scheduler /usr/local/bin/
cp kubernetes/server/bin/kube-proxy /usr/local/bin/
cp kubernetes/server/bin/kubelet /usr/local/bin/

# Install the executable binary of kubelet
cp kubernetes/platforms/linux/amd64/kubectl /usr/local/bin/

## Delete useless files and packages
rm -rf /tmp/*
apt-get remove -y ca-certificates
apt-get clean -y
apt-get autoremove -y