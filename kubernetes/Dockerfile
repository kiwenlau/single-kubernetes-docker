FROM ubuntu:14.04

MAINTAINER kiwenlau <kiwenlau@gmail.com>

WORKDIR /root

# Install Kubernetes by putting "hyperkube" and "kubctl" binaries in "/usr/local/bin/"
ADD install-kubernetes.sh /tmp/install-kubernetes.sh
RUN sh /tmp/install-kubernetes.sh

ADD pod-nginx.yaml /root/pod-nginx.yaml
ADD test-kubernetes.sh /root/test-kubernetes.sh

ADD pod-nginx-alauda.yaml /root/pod-nginx-alauda.yaml
ADD test-kubernetes-alauda.sh /root/test-kubernetes-alauda.sh
