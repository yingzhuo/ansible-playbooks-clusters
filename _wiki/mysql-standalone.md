# 搭建/配置单节点MySQL

#### 下载与解压

受网络限制，我们不打算采用使用`ansible`下载MySQL的二进制包。请自行下载并解压到`/usr/local/mysql`

## 安装

```bash
# 安装完成后root账号为空密码
ansible-playbook playbook.mysql-node.yml -e @./myvars/mysql/standalone.yml \
  -e "HOSTS=mysql_standalone"
```

## 初始化用户名密码

```sql
use mysql;

alter user 'root'@'localhost' identified with mysql_native_password by 'root';

update mysql.user
set host = '%'
where host = 'localhost'
  and user = 'root';

flush privileges;
```

#### 删除节点(可选)

```bash
ansible-playbook playbook.mysql-node-remove.yml -e @./myvars/mysql/standalone.yml \
  -e "HOSTS=mysql_standalone" -v
```

#### 安装`percona-toolkit`工具(可选)

[wiki](./percona-toolkit.md)