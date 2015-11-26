#!/bin/bash

# Run ectd container
echo "Starting ectd container..."
sudo docker run -d --name="etcd" kiwenlau/etcd:v2.2.1 \
                                      --addr=127.0.0.1:4001 \
                                      --bind-addr=0.0.0.0:4001 \
                                      --data-dir=/var/etcd/data 

# Run apiserver container
echo "Starting apiserver container..."
sudo docker run -d --link etcd:etcd --name="apiserver" kiwenlau/kubernetes:1.0.7 kube-apiserver \
                                                         --service-cluster-ip-range=10.0.0.1/24 \
                                                         --insecure-bind-address=0.0.0.0 \
                                                         --etcd_servers=http://etcd:4001

sleep 10

# Run controller-manager container
echo "Starting controller-manager container..."
sudo docker run -d --link apiserver:apiserver --name="controller-manager" kiwenlau/kubernetes:1.0.7 kube-controller-manager --master=http://apiserver:8080                                                                           

# Run scheduler container
echo "Starting scheduler container..."
sudo docker run -d --link apiserver:apiserver --name="scheduler" kiwenlau/kubernetes:1.0.7 kube-scheduler --master=http://apiserver:8080 
                                                                                                                  
# Run kubelet container
echo "Starting kubelet container..."
sudo docker run -d --link apiserver:apiserver --pid=host -v /var/run/docker.sock:/var/run/docker.sock --name="kubelet"  kiwenlau/kubernetes:1.0.7 kubelet \
                                                                                                                      --api_servers=http://apiserver:8080 \
                                                                                                                      --address=0.0.0.0 \
                                                                                                                      --hostname_override=127.0.0.1 \
                                                                                                                      --cluster_dns=10.0.0.10 \
                                                                                                                      --cluster_domain="kubernetes.local" \
                                                                                                                      --pod-infra-container-image="kiwenlau/pause:0.8.0"
                                                                                                   
# Run proxy container
echo "Starting proxy container..."
sudo docker run -d --link apiserver:apiserver --privileged --name="proxy" kiwenlau/kubernetes:1.0.7 kube-proxy --master=http://apiserver:8080 

#Run kubectl container
echo "Starting kubectl container..."                                                                 
sudo docker run -id --link apiserver:apiserver -e "KUBERNETES_MASTER=http://apiserver:8080" --name="kubectl" --hostname="kubectl" kiwenlau/kubernetes:1.0.7 bash 

#Get into the kubectl container
sudo docker exec -it kubectl bash

