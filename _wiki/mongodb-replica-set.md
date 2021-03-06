# 搭建/配置MongoDB副本集集群

## 下载与解压

受网络限制，我们不打算采用使用`ansible`下载MongoDB的二进制包。请自行下载并解压到`/usr/local/mongodb`

## 安装

```bash
# 安装第一个数据节点 (有可能当选主节点)
ansible-playbook playbook.mongodb-node.yml -e @./myvars/mongodb/replica-set-mongod-1.yml \
  -e "HOSTS=mongodb_rs_1" \
  -e "auth=disabled"

# 安装第二个数据节点 (有可能当选主节点)
ansible-playbook playbook.mongodb-node.yml -e @./myvars/mongodb/replica-set-mongod-2.yml \
  -e "HOSTS=mongodb_rs_2" \
  -e "auth=disabled"

# 安装仲裁者节点
ansible-playbook playbook.mongodb-node.yml -e @./myvars/mongodb/replica-set-mongod-arbiter.yml \
  -e "HOSTS=mongodb_rs_arbiter" \
  -e "auth=disabled"
```

## 初始化`replica set`

```bash
mongosh --host 10.211.55.3 --port 27017
```

```
use admin

rs.initiate( {
   _id : "my-replica-set",
   members: [
      { _id: 1, host: "10.211.55.3:27017", arbiterOnly: false },
      { _id: 2, host: "10.211.55.3:27018", arbiterOnly: false },
      { _id: 3, host: "10.211.55.3:27019", arbiterOnly: true }
   ]
})
```

## 初始化`root`用户

```bash
mongosh --host 127.0.0.1 --port 27017
```

```
use admin

db.createUser(
    {
        user: "root",
        pwd: "root",
        roles: [{role: "root", db: "admin"}]
    }
)
```

## 重启`MongoDB`集群并开启认证

```bash
ansible-playbook playbook.mongodb-node.yml -e @./myvars/mongodb/replica-set-mongod-1.yml \
  -e "HOSTS=mongodb_rs_1" \
  -e "auth=enabled"

ansible-playbook playbook.mongodb-node.yml -e @./myvars/mongodb/replica-set-mongod-2.yml \
  -e "HOSTS=mongodb_rs_2" \
  -e "auth=enabled"

ansible-playbook playbook.mongodb-node.yml -e @./myvars/mongodb/replica-set-mongod-arbiter.yml \
  -e "HOSTS=mongodb_rs_arbiter" \
  -e "auth=enabled"
```

## 删除集群(可选)

```bash
ansible-playbook playbook.mongodb-node-remove.yml -e @./myvars/mongodb/replica-set-mongod-1.yml \
  -e "HOSTS=mongodb_rs_1"

ansible-playbook playbook.mongodb-node-remove.yml -e @./myvars/mongodb/replica-set-mongod-2.yml \
  -e "HOSTS=mongodb_rs_2"

ansible-playbook playbook.mongodb-node-remove.yml -e @./myvars/mongodb/replica-set-mongod-arbiter.yml \
  -e "HOSTS=mongodb_rs_arbiter"
```

**注意：** 将删除所有的数据和配置文件但不会卸载依赖的软件和系统配置。

## 其他

##### (1) keyfile生成方式:

```bash
openssl rand -base64 755
```
