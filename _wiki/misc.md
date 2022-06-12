# 杂项设置

## 配置yum与yum仓库

```bash
ansible-playbook playbook.yum.yml -e "HOSTS=all"
```

## 安装和配置zsh 和 oh-my-zsh

```bash
ansible-playbook playbook.omz.yml -e "HOSTS=all"
```

## 重新配置ssh

```bash
ansible-playbook playbook.ssh.yml -e "HOSTS=all"
```

## 安装和配置vim

```bash
ansible-playbook playbook.vim.yml -e "HOSTS=all"
```

## 防火墙软件配置

```bash
ansible-playbook playbook.firewall.yml -e "HOSTS=all"
```

## SELINUX配置

```bash
ansible-playbook playbook.selinux.yml -e "HOSTS=all"
```

## 重新配置ulimits

```bash
# 重新登录即可生效
ansible-playbook playbook.ulimits.yml -e "HOSTS=all"
```

## 设置系统swap配置

```bash
ansible-playbook playbook.swap.yml -e "HOSTS=all"
```

## 配置ntp-client

```bash
ansible-playbook playbook.ntp.yml -e "HOSTS=all"
```

## 安装清理脚本

```bash
ansible-playbook playbook.cleanup-script.yml -e "HOSTS=all"
```

## 安装vsftpd

```bash
ansible-playbook playbook.vsftp.yml -e "HOSTS=vsftp"
```