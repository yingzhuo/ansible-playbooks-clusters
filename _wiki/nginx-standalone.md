# 安装/配置percona-toolkit

## 安装

```bash
ansible-playbook playbook.nginx.yml -e "HOSTS=nginx_standalone"
```

## 附录

#### (1) HttpBasic 用户名密码相关

```bash
htpasswd -cb <password_file> <username> <password>
```
