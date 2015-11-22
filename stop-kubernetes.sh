#!/bin/bash

# delete all containers of Kubernetes cluster
sudo docker rm -f kubectl
sudo docker rm -f proxy
sudo docker rm -f kubelet
sudo docker rm -f scheduler
sudo docker rm -f controller-manager
sudo docker rm -f apiserver
sudo docker rm -f etcd
