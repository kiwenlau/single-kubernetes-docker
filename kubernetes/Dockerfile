FROM ubuntu:14.04

WORKDIR /root

# Install Kubernetes by putting "hyperkube" and "kubctl" binaries in "/usr/local/bin/"
ADD install-kubernetes.sh /tmp/install-kubernetes.sh
RUN sh /tmp/install-kubernetes.sh

ADD pod-nginx.yaml /root/pod-nginx.yaml
ADD test-kubernetes.sh /root/test-kubernetes.sh
