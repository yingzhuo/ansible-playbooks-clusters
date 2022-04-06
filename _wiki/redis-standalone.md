# 搭建/配置单节点Redis

#### 安装

```bash
ansible-playbook playbook.redis-node.yml -e @./myvars/redis/standalone.yml -e "HOSTS=redis_standalone"
```

#### 删除节点(可选)

```bash
ansible-playbook playbook.redis-node-remove.yml -e @./myvars/redis/standalone.yml -e "HOSTS=redis_standalone"
```

**注意：** 将删除所有的数据和配置文件但不会卸载依赖的软件和系统配置。
