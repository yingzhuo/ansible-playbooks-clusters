# 搭建/配置单节点RabbitMQ

## 下载与解压

受网络限制，我们不打算采用使用`ansible`下载rabbitmq的二进制包。请自行下载并解压到`/usr/local/rabbitmq`

## 安装

```bash
ansible-playbook playbook.rabbitmq-server.yml -e @./myvars/rabbitmq/standalone.yml \
  -e "HOSTS=rabbitmq_standalone"
```

## 初始化账号

```bash
# 开启web插件
rabbitmq-plugins enable rabbitmq_management

# 添加vhost
# rabbitmqctl add_vhost /vhost1

# 添加用户并设置权限
rabbitmqctl add_user root root
rabbitmqctl set_user_tags root administrator
rabbitmqctl set_permissions -p "/" root ".*" ".*" ".*"
```

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
ansible-playbook playbook.rabbitmq-server-remove.yml -e @./myvars/rabbitmq/standalone.yml "HOSTS=mongodb_standalone"
```

**注意：** 将删除所有的数据和配置文件但不会卸载依赖的软件和系统配置。
