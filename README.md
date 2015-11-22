#基于Docker快速搭建单机版Kuberntes


##1. 基本信息

GitHub地址: [https://github.com/kiwenlau/single-kubernetes-docker](https://github.com/kiwenlau/single-kubernetes-docker)

博客地址:

kiwenlau/kubernetes:1.0.7镜像版本信息:

- ubuntu: 14.04
- Kubernetes: 1.0.7
- ectd: 2.2.1

Ubuntu主机版本信息:

- ubuntu: 14.04.3 LTS
- kernel: 3.16.0-30-generic
- docker: 1.9.1

##2. 镜像简介



##3. 运行步骤

**1. 安装Docker**

参考: [https://docs.docker.com/](https://docs.docker.com/)

**2. 启动Kubernetes**

```sh
git clone https://github.com/kiwenlau/single-kubernetes-docker
cd single-kubernetes-docker/
sudo chmod +x start-kubernetes.sh 
sudo ./start-kubernetes.sh 
```

运行结束后进入kubectl容器。容器主机名为kubeclt。


**3. 测试kubernetes**

运行测试脚本，该脚本会启动一个nginx pod。

```
./test-kubernetes.sh 
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
