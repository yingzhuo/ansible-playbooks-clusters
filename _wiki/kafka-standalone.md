# 搭建/配置Kafka单节点服务

## 下载与解压

受网络限制，我们不打算采用使用`ansible`下载Kafka的二进制包。请自行下载并解压到`/usr/local/kafka`

## 安装

```bash
ansible-playbook playbook.kafka-broker.yml -e @./myvars/kafka/standalone.yml \
  -e "HOSTS=kafka_standalone"
```
