#!/bin/bash

echo ""
echo "kubectl create -f pod-nginx.yaml"
kubectl create -f pod-nginx.yaml

echo ""

echo "kubectl get pods/nginx"
echo ""

while [[ true ]]; do
        kubectl get pods/nginx
        nginxPod=`kubectl get pods/nginx | grep Running | grep 1/1`
        if [[ $nginxPod ]]; then
                break
        fi
        sleep 2
done

echo ""

while [[ true ]]; do
        nginxIP=`kubectl describe pods/nginx | grep IP`
        IP=${nginxIP:7}
        if [[ "$IP" ]]; then
                echo ""
                echo "The IP address of Nginx Pod is: $IP"
                echo ""
                echo "wget -qO- $IP"
                echo ""
                wget -qO- $IP
                echo ""
                break
        fi
done
