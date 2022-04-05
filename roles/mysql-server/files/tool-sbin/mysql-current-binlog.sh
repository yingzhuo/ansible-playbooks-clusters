#!/usr/bin/env bash
# 检查当前binlog使用情况
# 作者: 应卓

sql="show master status;"

cat << 'EOF' > /tmp/mysql-check-binlog.awk
NR == 2 {
  printf("DELETE old binary logs:\n")
  printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
  printf("mysql -e \"purge binary logs to '%s';\"\n", $1)
  printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
}
EOF

mysql -e "$sql" | awk -f /tmp/mysql-check-binlog.awk

[[ -f /tmp/mysql-check-binlog.awk ]] && rm -rf /tmp/mysql-check-binlog.awk
