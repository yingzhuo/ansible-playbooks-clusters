## MongoDB主从集群 集群搭建

![replica-set-primary-with-secondary-and-arbiter](./replica-set-primary-with-secondary-and-arbiter.svg)

命令:

```bash
ansible-playbook ./playbook.mongodb-rs.yml -v
```

安装完成后要登录到`27017`节点任意一个节点初始化整个集群。

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
