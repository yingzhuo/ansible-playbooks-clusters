# 升级kernel到主线版本

## 安装

```bash
ansible-playbook playbook.kernel.yml -e "HOSTS=all"
```

## 其他

建议安装好新的mainline内核以后删除旧内核。有两种方式:

```bash
# 查看
rpm -q kernel
# 删除
yum remove <内核名称>
```

```bash
# 自动删除
sudo package-cleanup --oldkernels --count=2
```
