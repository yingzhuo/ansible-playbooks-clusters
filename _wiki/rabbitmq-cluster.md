# 搭建/配置RabbitMQ集群

## 下载与解压

受网络限制，我们不打算采用使用`ansible`下载rabbitmq的二进制包。请自行下载并解压到`/usr/local/rabbitmq`

## 安装

```bash
ansible-playbook playbook.rabbitmq-server.yml -e @./myvars/rabbitmq/cluster-node-1.yml -e "HOSTS=rabbitmq_cluster_1"
ansible-playbook playbook.rabbitmq-server.yml -e @./myvars/rabbitmq/cluster-node-2.yml -e "HOSTS=rabbitmq_cluster_2"
ansible-playbook playbook.rabbitmq-server.yml -e @./myvars/rabbitmq/cluster-node-3.yml -e "HOSTS=rabbitmq_cluster_3"
```
