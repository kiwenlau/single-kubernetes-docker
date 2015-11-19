# Download Docker images
# sudo docker pull quay.io/coreos/etcd:v2.2.1
# sudo docker pull kiwenlau/kubernetes:1.0.7  

# Run ectd container
echo "Starting ectd container..."
sudo docker run --net=host -d --name="etcd" quay.io/coreos/etcd:v2.2.1 \
                                                 --addr=127.0.0.1:4001 \
                                                 --bind-addr=0.0.0.0:4001 \
                                                 --data-dir=/var/etcd/data 
                                                 

# Run apiserver container
echo "Starting apiserver container..."
sudo docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock --name="apiserver" kiwenlau/kubernetes:1.0.7 kube-apiserver \
                                                                                                    --service-cluster-ip-range=10.0.0.1/24 \
                                                                                                    --insecure-bind-address=0.0.0.0 \
                                                                                                    --etcd_servers=http://127.0.0.1:4001 \
                                                                                                    --cluster_name=kubernetes \
                                                                                                    --v=2 
                                                                                                    
sleep 10

# Run controller-manager container
echo "Starting controller-manager container..."
sudo docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock --name="controller-manager" kiwenlau/kubernetes:1.0.7 kube-controller-manager \
                                                                                                                                     --master=127.0.0.1:8080 \
                                                                                                                                     --v=2 
                                                                                                                                     


# Run scheduler container
echo "Starting scheduler container..."
sudo docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock --name="scheduler" kiwenlau/kubernetes:1.0.7 kube-scheduler \
                                                                                                                   --master=127.0.0.1:8080 \
                                                                                                                   --v=2 
                                                                                                                   


# Run kubelet container
echo "Starting kubelet container..."
sudo docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock --name="kubelet" kiwenlau/kubernetes:1.0.7 kubelet \
                                                                                                   --api_servers=http://127.0.0.1:8080 \
                                                                                                   --v=2 \
                                                                                                   --address=0.0.0.0 \
                                                                                                   --hostname_override=127.0.0.1 \
                                                                                                   --cluster_dns=10.0.0.10 \
                                                                                                   --cluster_domain="kubernetes.local" \
                                                                                                   --config=/etc/kubernetes/manifests 
                                                                                                   


# Run proxy container
echo "Starting proxy container..."
sudo docker run -d --net=host --privileged --name="proxy" kiwenlau/kubernetes:1.0.7 kube-proxy \
                                                                    --master=http://127.0.0.1:8080 \
                                                                    --v=2 
                                                                    


# Run kubectl container
echo "Starting kubectl container..."
sudo docker run --net=host -id -v /var/run/docker.sock:/var/run/docker.sock --name="kubectl" kiwenlau/kubernetes:1.0.7 bash 

# Get into kubectl container
sudo docker exec -it kubectl bash

                            






