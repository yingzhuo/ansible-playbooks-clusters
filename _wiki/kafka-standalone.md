# 搭建/配置Kafka单节点服务

## 下载与解压

受网络限制，我们不打算采用使用`ansible`下载Kafka的二进制包。请自行下载并解压到`/usr/local/kafka`

## 安装

```bash
ansible-playbook playbook.kafka-broker.yml -e @./myvars/kafka/standalone.yml -e "HOSTS=kafka_standalone"
```

## 删除节点(可选)

```bash
ansible-playbook playbook.kafka-broker-remove.yml -e @./myvars/kafka/standalone.yml -e "HOSTS=kafka_standalone"
```

**注意：** 将删除所有的数据和配置文件但不会卸载依赖的软件和系统配置。

## 参考

* [SSL双向验证](./kafka-ssl.md)
