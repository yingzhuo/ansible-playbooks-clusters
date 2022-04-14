# 搭建/配置Zabbix监控端

## 安装

```bash
ansible-playbook playbook.zabbix-server.yml -e "HOSTS=zabbix_server"
```

## 初始化MySQL数据库

```sql
-- 创建数据库
drop database if exists zabbix;
create database zabbix character set utf8 collate utf8_bin;

-- 创建用户
drop user if exists 'zabbix'@'%';
create user 'zabbix'@'%' identified with mysql_native_password by 'zabbix';
grant all on zabbix.* to 'zabbix'@'%';
```

```bash
zcat /usr/share/doc/zabbix-server-mysql-4.4.10/create.sql.gz | mysql -uzabbix -p zabbix
```

## 初始化`zabbix`

使用Web浏览器即可
