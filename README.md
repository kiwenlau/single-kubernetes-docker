#基于Docker快速搭建单机版Kuberntes

- Kubernetes版本: 1.0.7

- ectd版本: 2.2.1

运行环境:

- ubuntu:
- kernel:
- docker:

##运行步骤

**1. 安装Docker**

参考: [https://docs.docker.com/](https://docs.docker.com/)

**2. 启动Kubernetes**

```sh
git clone https://github.com/kiwenlau/single-kubernetes-docker
cd single-kubernetes-docker/
sudo chmod +x start-kubernetes.sh 
sudo ./start-kubernetes.sh 
```

运行结束后进入kubectl容器

**3. 测试kubernetes**

查看Kubernetes版本

```
kubectl version
```

输出如下，可知Kubernetes的版本为: 1.0.7

```
Client Version: version.Info{Major:"1", Minor:"0", GitVersion:"v1.0.7", GitCommit:"6234d6a0abd3323cd08c52602e4a91e47fc9491c", GitTreeState:"clean"}
Server Version: version.Info{Major:"1", Minor:"0", GitVersion:"v1.0.7", GitCommit:"6234d6a0abd3323cd08c52602e4a91e47fc9491c", GitTreeState:"clean"}
```


```
kubectl create -f pod-nginx.yaml
```

查看pod

```
kubectl get pod
```

当NAME为nginx的pod状态变为running时，可以通过kubectl describe命令获取其IP

```
kubectl describe pods/nginx | grep IP
```

输出如下，可知NAME为niginx的pod的IP为**172.17.0.2**

```		
IP:				172.17.0.2
```

测试nginx

```
wget -qO- 172.17.0.2
```

输出

```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

**4.关闭Kubernetes集群**

删除所有pod

```
kubectl delete pods --all
``` 

退出kubectl容器

```
exit
```

关闭Kubernetes集群的所有容器

```
sudo chmod +x ./stop-kubernetes.sh 
sudo ./stop-kubernetes.sh 
```


##参考
1. [meteorhacks/hyperkube](https://github.com/meteorhacks/hyperkube)
2. [meteorhacks/kube-init](https://github.com/meteorhacks/kube-init)
3. [Kubernetes: The Future of Cloud Hosting](https://meteorhacks.com/learn-kubernetes-the-future-of-the-cloud)
