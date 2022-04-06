# 搭建/配置Redis集群

#### 安装

```bash
ansible-playbook playbook.redis-node.yml -e @./myvars/redis/scaling-cluster-1.yml -e "HOSTS=redis_sc_1"
ansible-playbook playbook.redis-node.yml -e @./myvars/redis/scaling-cluster-2.yml -e "HOSTS=redis_sc_2"
ansible-playbook playbook.redis-node.yml -e @./myvars/redis/scaling-cluster-3.yml -e "HOSTS=redis_sc_3"
ansible-playbook playbook.redis-node.yml -e @./myvars/redis/scaling-cluster-4.yml -e "HOSTS=redis_sc_4"
ansible-playbook playbook.redis-node.yml -e @./myvars/redis/scaling-cluster-5.yml -e "HOSTS=redis_sc_5"
ansible-playbook playbook.redis-node.yml -e @./myvars/redis/scaling-cluster-6.yml -e "HOSTS=redis_sc_6"
```

#### 组建集群

```bash
redis-cli \
  --askpass \
  --cluster-replicas 1 \
  --cluster create \
  10.211.55.3:6379 \
  10.211.55.3:6380 \
  10.211.55.3:6381 \
  10.211.55.3:6382 \
  10.211.55.3:6383 \
  10.211.55.3:6384
```

#### 删除集群(可选)

```bash
ansible-playbook playbook.redis-node-remove.yml -e @./myvars/redis/scaling-cluster-1.yml -e "HOSTS=redis_sc_1"
ansible-playbook playbook.redis-node-remove.yml -e @./myvars/redis/scaling-cluster-2.yml -e "HOSTS=redis_sc_2"
ansible-playbook playbook.redis-node-remove.yml -e @./myvars/redis/scaling-cluster-3.yml -e "HOSTS=redis_sc_3"
ansible-playbook playbook.redis-node-remove.yml -e @./myvars/redis/scaling-cluster-4.yml -e "HOSTS=redis_sc_4"
ansible-playbook playbook.redis-node-remove.yml -e @./myvars/redis/scaling-cluster-5.yml -e "HOSTS=redis_sc_5"
ansible-playbook playbook.redis-node-remove.yml -e @./myvars/redis/scaling-cluster-6.yml -e "HOSTS=redis_sc_6"
```

**注意：** 将删除所有的数据和配置文件但不会卸载依赖的软件和系统配置。
