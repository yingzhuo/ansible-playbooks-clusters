# 搭建/配置单节点ElasticSearch服务

## 下载与解压

受网络限制，我们不打算采用使用`ansible`下载ElasticSearch的二进制包。请自行下载并解压到`/usr/local/elasticsearch`

## 安装

```bash
ansible-playbook playbook.elasticsearch.yml -e @./myvars/elasticsearch/standalone.yml -e "HOSTS=elasticsearch_standalone"
```