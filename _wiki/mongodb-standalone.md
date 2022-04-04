# 搭建/配置单节点MongoDB

#### 下载与解压

受网络限制，我们不打算采用使用`ansible`下载MongoDB的二进制包。请自行下载并解压到`/usr/local/mongodb`

#### 安装命令

```bash
ansible-playbook playbook.mongodb-node.yml -e @./myvars/mongodb/standalone.yml \
  -e "HOSTS=mongodb_standalone" \
  -e "auth=disabled"
```

#### 初始化`root`用户

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

#### 重启`MongoDB`并开启认证

```bash
ansible-playbook playbook.mongodb-node.yml -e @./myvars/mongodb/standalone.yml \
  -e "HOSTS=mongodb_standalone" \
  -e "auth=enabled"
```

#### 删除节点(可选)

```bash
ansible-playbook playbook.mongodb-node-remove.yml -e @./myvars/mongodb/standalone.yml \
  -e "HOSTS=mongodb_standalone"
```

**注意：** 将删除所有的数据和配置文件但不会卸载依赖的软件和系统配置。
