#基于Docker快速搭建单机版Kuberntes


GitHub地址: [https://github.com/kiwenlau/single-kubernetes-docker](https://github.com/kiwenlau/single-kubernetes-docker)

博客地址:


##1. Kubernetes简介

2006年，Google工程师Rohit Seth发起了Cgroups内核项目。Cgroups是容器实现CPU，内存等资源隔离的基础，由此可见Google其实很早就开始涉足容器技术。而事实上，Google内部使用容器技术已经长达十年，目前谷歌所有业务包括搜索，Gmail，MapReduce等均运行在容器之中。Google内部使用的集群管理系统--Borg，堪称其容器技术的瑞士军刀。

2014年，Google发起了开源容器集群管理系统--Kubernetes，其设计之初就吸取了Borg的经验和教训，并原生支持了Docker。因此，Kubernetees与较早的集群管理系统Mesos和YARN相比，对容器尤其是Docker的支持更加原生，同时提供了更强大的机制实现资源调度，负载均衡，高可用等底层功能，使开发者可以专注于开发应用。

与其他集群系统一致，Kubernetes也采用了Master/Slave结构。下表显示了Kubernetes的各个组件及其功能。

| 角色     | 组件               | 功能                                           |
| ------- |:-----------------: | :--------------------------------------------:|
| Master  | apiserver          | 提供RESTful接口                                |
| Master  | scheduler          | 负责调度，将pod分配到Slave节点                   |
| Master  | controller-manager | 负责Master的其他功能                           |
| Master  | etde               | 储存配置信息，节点信息，pod信息等                 |
| Slave   | kubelet            | 负责管理Pod,容器和容器镜像                       |
| Slave   | proxy              | 将访问Service的请求转发给对应的Pod，做一些负载均衡  |
| 客户端   | kubectl            | 命令行工具，向apiserver发起创建Pod等请求          |


##2. kiwenlau/kubernetes镜像简介

下图显示了我在Ubuntu主机上运行单机版Kubernetes的架构。可知，我一共运行了7个容器，分别运行Kubernetes的各个组件。事实上，Kuberenetes未来的开发目标正是将Kubernetes的各个组件运行到容器之中，这样可以方便Kubernetes的部署和升级。现在我将Kubernetes的各个组件全部运行在容器中必然存在很多问题且很多问题是未知的，因此这个项目仅做学习测试而不宜部署到生产环境中。Kubernetes各个组件容器之间的通信通过docker link实现，其中apiserver与ectd的4001端口进行通信，scheduler，controller-manager，kubelet，proxy以及kubectl与apiserver的8080端口进行通信。

![alt text](https://github.com/kiwenlau/single-kubernetes-docker/raw/master/single-kubernetes-docker.png "Image Architecture")

集群的大致运行流程是这样的: 用户通过kubectl命令向apiserver发起创建Pod的请求; scheduler将创建Pod的任务分配给kubelet；kubelet中包含了一个docker命令行工具，该工具会向Docker deamon发起创建容器的请求; Docker deamon负责下载镜像然后创建容器。

我将Docker deamon运行在Ubuntu主机上，因此Docker daemon所创建的应用容器与Kubernetes各个组件的容器均运行在Ubuntu主机上。docker socket采用volume的形式挂载到kubelet容器内，因此kubelet中的docker命令行工具可以直接与主机上的Docker daemon进行通信。

我是直接将kubernetes发布的各个组件的二进制可执行文件安装在/usr/local/bin目录下，因此，修改Dockerfile中的Kubernetes下载链接的版本号，就可以快速构建其他版本的Kubernetes镜像。另外，仅需修改网络配置，就可以很方便地在多个节点上部署Kubernetes。

kiwenlau/kubernetes:1.0.7镜像版本信息:

- ubuntu: 14.04
- Kubernetes: 1.0.7
- ectd: 2.2.1

Ubuntu主机版本信息:

- ubuntu: 14.04.3 LTS
- kernel: 3.16.0-30-generic
- docker: 1.9.1



##3. 运行步骤

**1. 安装Docker**

ubuntu 14.04上安装Docker: 

```
curl -fLsS https://get.docker.com/ | sh
```

其他系统请参考: [https://docs.docker.com/](https://docs.docker.com/)

**2. 下载Docker镜像**

我将kiwenlau/kubernetes:1.07以及其他用到的Docker镜像都放在[灵雀云](http://www.alauda.cn/)

```
sudo docker pull index.alauda.cn/kiwenlau/kubernetes:1.0.7
sudo docker pull index.alauda.cn/kiwenlau/etcd:v2.2.1
sudo docker pull index.alauda.cn/kiwenlau/nginx:1.9.7
sudo docker pull index.alauda.cn/kiwenlau/pause:0.8.0
```

**3. 启动Kubernetes**

```sh
git clone https://github.com/kiwenlau/single-kubernetes-docker
cd single-kubernetes-docker/
sudo chmod +x start-kubernetes-alauda.sh stop-kubernetes.sh
sudo ./start-kubernetes-alauda.sh
```

运行结束后进入kubectl容器。容器主机名为kubeclt。可以通过"exit"命令退出容器返回到主机，然后可以通过"sudo docker exec -it kubectl bash"命令再次进入kubectl容器。


**4. 测试Kubernetes**

运行测试脚本，该脚本会启动一个nginx pod。

```
chmod +x test-kubernetes-alauda.sh
./test-kubernetes-alauda.sh 
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

**5.关闭Kubernetes集群**

删除所有pod

```
kubectl delete pods --all
``` 

退出kubectl容器

```
exit
```

删除Kubernetes所有组件的容器

```
sudo ./stop-kubernetes.sh 
```


##4. 参考
1. [meteorhacks/hyperkube](https://github.com/meteorhacks/hyperkube)
2. [meteorhacks/kube-init](https://github.com/meteorhacks/kube-init)
3. [Kubernetes: The Future of Cloud Hosting](https://meteorhacks.com/learn-kubernetes-the-future-of-the-cloud)
4. [Kubernetes 架构浅析](http://weibo.com/p/1001603912843031387951?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io)
5. [An Introduction to Kubernetes](https://www.digitalocean.com/community/tutorials/an-introduction-to-kubernetes)




#Quickly run Kubernets on single host based on Docker

##1. Steps to run

**1. Install Docker**

Install Docker on ubuntu 14.04: 

```
curl -fLsS https://get.docker.com/ | sh
```

For other OS: [https://docs.docker.com/](https://docs.docker.com/)

**2. pull Docker images**

I put all images in my Docker Hub repository

```
sudo docker pull kiwenlau/kubernetes:1.0.7
sudo docker pull kiwenlau/etcd:v2.2.1
sudo docker pull kiwenlau/nginx:1.9.7
sudo docker pull kiwenlau/pause:0.8.0
```

**3. Start Kubernetes**

```sh
git clone https://github.com/kiwenlau/single-kubernetes-docker
cd single-kubernetes-docker/
sudo chmod +x start-kubernetes.sh stop-kubernetes.sh
sudo ./start-kubernetes.sh
```

You will enter kubectl container after these commands.


**4. Test Kubernetes**

Run test script, this will start a nginx pod

```
chmod +x test-kubernetes.sh
./test-kubernetes.sh 
```

Output:

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

**5.Stop Kubernetes**

Delete all pods

```
kubectl delete pods --all
``` 

Exit kubectl container

```
exit
```

Stop Kubernetes

```
sudo ./stop-kubernetes.sh
```

##5. References
1. [meteorhacks/hyperkube](https://github.com/meteorhacks/hyperkube)
2. [meteorhacks/kube-init](https://github.com/meteorhacks/kube-init)
3. [Kubernetes: The Future of Cloud Hosting](https://meteorhacks.com/learn-kubernetes-the-future-of-the-cloud)
4. [An Introduction to Kubernetes](https://www.digitalocean.com/community/tutorials/an-introduction-to-kubernetes)
