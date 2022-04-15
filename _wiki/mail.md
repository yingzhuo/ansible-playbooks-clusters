# 安装和配置邮件发送脚本

## 安装

```bash
ansible-playbook playbook.mail.yml -e "HOSTS=mail_client" -e "auth_passwd=<密码>"
```

安装`mailx`并完成配置后可以通过`yingzhor@qq.com`发送邮件给`yingzhor@qq.com`

#### 简单测试脚本 1:

```bash
echo "Your message" | mail -v -s "Message Subject" "yingzhor@qq.com"
```

#### 简单测试脚本 2:

```bash
#!/usr/bin/env bash
# 提示: 本脚本也可作为zabbix alertscripts使用

to=$1
subject=$2
body=$3
cat <<EOF | mail -v -s "$subject" "$to"
$body
EOF
```
