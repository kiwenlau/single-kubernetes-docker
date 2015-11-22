#!/bin/bash

kubectl create -f pod-nginx.yaml

sleep 10

nginxIP=`kubectl describe pods/nginx | grep IP` 

IP=${nginxIP:}