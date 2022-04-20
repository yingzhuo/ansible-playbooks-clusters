# 搭建/配置Zookeeper集群

## 下载与解压

受网络限制，我们不打算采用使用`ansible`下载Zookeeper的二进制包。请自行下载并解压到`/usr/local/zookeeper`

## 安装

```bash
ansible-playbook playbook.zookeeper-broker.yml -e @./myvars/zookeeper/cluster-1.yml -e "HOSTS=zookeeper_cluster_1"
ansible-playbook playbook.zookeeper-broker.yml -e @./myvars/zookeeper/cluster-2.yml -e "HOSTS=zookeeper_cluster_2"
ansible-playbook playbook.zookeeper-broker.yml -e @./myvars/zookeeper/cluster-3.yml -e "HOSTS=zookeeper_cluster_3"
```

## 删除节点(可选)

```bash
ansible-playbook playbook.zookeeper-broker-remove.yml -e @./myvars/zookeeper/cluster-1.yml -e "HOSTS=zookeeper_cluster_1"
ansible-playbook playbook.zookeeper-broker-remove.yml -e @./myvars/zookeeper/cluster-2.yml -e "HOSTS=zookeeper_cluster_2"
ansible-playbook playbook.zookeeper-broker-remove.yml -e @./myvars/zookeeper/cluster-3.yml -e "HOSTS=zookeeper_cluster_3"
```

**注意：** 将删除所有的数据和配置文件但不会卸载依赖的软件和系统配置。