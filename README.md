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

##2. Kubernetes简介

2006年，Google工程师Rohit Seth发起了Cgroups项目。Cgroups是容器实现CPU，内存等资源隔离的基础，由此可知Google很早就涉足容器技术。而事实上，Google使用容器技术已经长达十年，目前谷歌所有业务包括搜索，Gmail，MapReduce等均运行在容器之中。Google内部使用的集群管理系统--Borg，堪称其容器技术的瑞士军刀。

2014年，Google发起了开源容器集群管理系统--Kubernetes，其设计之初就吸取了Borg的经验和教训，并原生支持了Docker。因此，Kubernetees与较早的集群管理系统Mesos和YARN相比，提供了更多灵活的机制实现高可用等底层功能，使开发者可以专注于开发应用。

与其他集群系统一致，Kubernetes也采用了Master/Slave结构。下表显示了Kubernetes的组件及其功能。

| 角色     | 组件               | 功能  |
| ------- |:-----------------: | :--------------------------------------------:|
| Master  | apiserver          | 提供RESTful接口                               |
| Master  | scheduler          | 负责调度，将pod分配到Slave节点                  |
| Master  | controller-manager | 负责Master的其他功能                           |
| Master  | etde               | 储存配置信息，节点信息，pod信息等                 |
| Slave   | kubelet            | 负责管理Pod,容器和容器镜像                       |
| Slave   | proxy              | 将访问Service的请求转发给对于的Pod，做一些负载均衡  |
| 客户端   | kubectl            | 命令行工具，向apiserver发起创建Pod等请求          |



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
