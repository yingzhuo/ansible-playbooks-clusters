# 搭建/配置RabbitMQ集群

## 下载与解压

受网络限制，我们不打算采用使用`ansible`下载rabbitmq的二进制包。请自行下载并解压到`/usr/local/rabbitmq`

## 安装

```bash
ansible-playbook playbook.rabbitmq-server.yml -e @./myvars/rabbitmq/cluster-node-1.yml -e "HOSTS=rabbitmq_cluster_1"
ansible-playbook playbook.rabbitmq-server.yml -e @./myvars/rabbitmq/cluster-node-2.yml -e "HOSTS=rabbitmq_cluster_2"
ansible-playbook playbook.rabbitmq-server.yml -e @./myvars/rabbitmq/cluster-node-3.yml -e "HOSTS=rabbitmq_cluster_3"
```

安装成功以后会得到三台互相独立的rabbitmq实例。它们的名字分别是:

* bunny1@vm01
* bunny2@vm01
* bunny2@vm01

## 构建集群

```bash
# bunny2 node linux
rabbitmqctl stop_app --node bunny2@vm01
rabbitmqctl join_cluster bunny1@vm01 --node bunny2@vm01
rabbitmqctl start_app --node bunny2@vm01

# bunny3 node linux
rabbitmqctl stop_app --node bunny3@vm01
rabbitmqctl join_cluster bunny1@vm01 --node bunny3@vm01
rabbitmqctl start_app --node bunny3@vm01

# check
rabbitmqctl cluster_status --node bunny1@vm01
```

讲两台机器加入`bunny01`即可

## 初始化用户名密码

```bash
rabbitmqctl add_user root root --node bunny1@vm01
rabbitmqctl set_user_tags root administrator --node bunny1@vm01
rabbitmqctl set_permissions -p "/" root ".*" ".*" ".*" --node bunny@vm01
```

## 设置镜像交换机与镜像队列策略

| Virtual Host | Name    | Regex Pattern | Apply To | Definition                                                   |
| ------------ | ------- | ------------- | -------- | ------------------------------------------------------------ |
| /            | mirror2 | ^mirror2.*$   | all      | ha-mode = exactly<br>ha-params = 2<br>ha-sync-mode = automatic |
| /            | mirror3 | ^mirror3.*$   | all      | ha-mode = exactly<br/>ha-params = 3<br/>ha-sync-mode = automatic |

如上面的例子，在名为"/"的vhost下，名称以"mirror2"和"mirror3"开始的队列或交换机会自动备份。

## 其他插件

#### shovel (官方)

```bash
# 需重启服务或集群
rabbitmq-plugins enable rabbitmq_shovel
rabbitmq-plugins enable rabbitmq_shovel_management
```

#### [rabbitmq-delayed-message-exchange (社区)](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange)

```bash
# 需重启服务或集群
cp rabbitmq_delayed_message_exchange-*.ez $RABBITMQ_HOME/plugins
chown rabbitmq:rabbitmq $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-*.ez
rabbitmq-plugins enable rabbitmq_delayed_message_exchange
```

## 其他

```bash
ansible-playbook playbook.rabbitmq-server-remove.yml -e @./myvars/rabbitmq/cluster-node-1.yml -e "HOSTS=rabbitmq_cluster_1"
ansible-playbook playbook.rabbitmq-server-remove.yml -e @./myvars/rabbitmq/cluster-node-2.yml -e "HOSTS=rabbitmq_cluster_2"
ansible-playbook playbook.rabbitmq-server-remove.yml -e @./myvars/rabbitmq/cluster-node-3.yml -e "HOSTS=rabbitmq_cluster_3"
```

**注意：** 将删除所有的数据和配置文件但不会卸载依赖的软件和系统配置。
