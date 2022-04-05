# 安装/配置percona-toolkit

## 安装

```bash
ansible-playbook playbook.percona-toolkit.yml -e @./myvars/percona/toolkit.yml \
  -e "HOSTS=mysql_standalone" -v
```
