# 搭建/配置单节点Caddy

## 下载与解压

受网络限制，我们不打算采用使用`ansible`下载Caddy的二进制包。请自行下载并解压到`/usr/local/caddy`

## 安装

```bash
ansible-playbook playbook.caddy.yml -e @./myvars/caddy/standalone.yml -e "HOSTS=caddy_standalone"
```