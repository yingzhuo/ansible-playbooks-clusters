# 搭建/配置单节点RabbitMQ

## 安装

```bash
ansible-playbook playbook.rabbitmq-server.yml -e @./myvars/rabbitmq/standalone.yml \
  -e "HOSTS=rabbitmq_standalone"
```
