## MongoDB主从集群 集群搭建

#### 命令

```bash
ansible-playbook ./playbook.mongodb-rs.yml -v
```

#### 其他

##### (1) 安装完成后要登录到`27017`节点初始化整个集群。

```javascript
// _id 务必指定为集群名称
// 角色: 
//  10.211.55.3:27017 -> 数据节点 (有可能当选为主节点)
//  10.211.55.3:27018 -> 数据节点 (有可能当选为主节点)
//  10.211.55.3:27019 -> 仲裁节点 (不可能当选为主节点)

rsconfig = {
    _id: "my-replication-set",
    members: [
        {_id: 0, host: "10.211.55.3:27017", arbiterOnly: false},
        {_id: 1, host: "10.211.55.3:27018", arbiterOnly: false},
        {_id: 2, host: "10.211.55.3:27019", arbiterOnly: true}
    ]
}

rs.initiate(rsconfig)
```

##### (2) 创建`root`用户

```javascript
db.createUser(
    {
        user: "root",
        pwd: "root",
        roles: [{role: "root", db: "admin"}]
    }
)

db.createUser(
    {
        user: "test",
        pwd: "test",
        roles: [{role: "readWrite", db: "test"}]
    }
)
```

之后就可以已以下的uri访问集群了。

```
mongodb://root:root@10.211.55.3:27017,10.211.55.3:27018,10.211.55.3:27019/test?authSource=admin&ssl=false
```

##### (3) keyfile生成方式

```bash
openssl rand -base64 90 -out ./mongodb.key
```
