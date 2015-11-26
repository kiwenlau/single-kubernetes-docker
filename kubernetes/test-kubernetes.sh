#!/bin/bash

echo -e "\nkubectl create -f pod-nginx.yaml"
kubectl create -f pod-nginx.yaml

echo -e "\nkubectl get pods/nginx\n"

while [[ true ]]; do
        kubectl get pods/nginx
        nginxPod=`kubectl get pods/nginx | grep Running | grep 1/1`
        if [[ $nginxPod ]]; then
                break
        fi
        sleep 2
done

echo ""

nginxIP=`kubectl describe pods/nginx | grep IP`
IP=${nginxIP:7}
echo -e "The IP address of Nginx Pod is: $IP\n"
echo -e "wget -qO- $IP\n"
wget -qO- $IP
echo ""
