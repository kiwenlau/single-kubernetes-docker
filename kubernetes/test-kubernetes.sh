#!/bin/bash

kubectl create -f pod-nginx.yaml

while [[ true ]]; do
	nginxPod=`kubectl get pods/nginx | grep Running`
	if [[ $nginxPod ]]; then
		echo "nginx pod is running"
		break
	fi
done

while [[ 1 ]]; do
	nginxIP=`kubectl describe pods/nginx | grep IP`
	IP=${nginxIP:7}
	if [[ "$IP" ]]; then
		wget -qO- $IP
		break
	fi
done