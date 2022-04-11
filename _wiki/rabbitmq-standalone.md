# 搭建/配置单节点RabbitMQ

#### 下载与解压

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
