# 安装/配置percona-toolkit

## 安装

```bash
ansible-playbook playbook.percona-toolkit.yml -e @./myvars/percona/toolkit.yml \
  -e "HOSTS=mysql_standalone"
```

## 附录

#### 附录(1) 常用DDL指南

| 功能                 | 是否锁表 | pt-online-schema-change 指令模板                             | sql                                                          |
| :------------------- | -------- | :----------------------------------------------------------- | ------------------------------------------------------------ |
| 变更数据库默认字符集 | -        | <不支持也不需要>                                             | ALTER DATABASE test CHARACTER SET utf8mb4 COLLATE utf8mb4_bin |
| 变更表字符集         | yes      | pt-online-schema-change --alter 'CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin' D=test,t=x --dry-run | -                                                            |
| 添加索引             | no       | pt-online-schema-change --alter 'ADD INDEX indx_b (b)' D=test,t=x --dry-run | -                                                            |

**注意:** 处理外键时请合理使用`--alter-foreign-keys-method=rebuild_constraints`选项。

#### 附录(2) 本人编写的awk脚本，用于分析慢查询文本日志

```awk
BEGIN {
    IGNORECASE = 1
    timestamp = ""
    query_time = ""
    lock_time = ""
    rows_send = ""
    rows_examined = ""
    sql = ""
}

{
    # 获取日志日期
    if ($0 ~ /^# Time:.*$/) {
        timestamp = $3
    }

    # 获取日志信息
    if ($0 ~ /^# Query_time:.*$/) {
        query_time = $3
        lock_time = $5
        rows_send = $7
        rows_examined = $9
    }

    if ($0 ~ /^select.*$/) {
        sql = $0
        printf("时间戳: %s - 查询时间: %s秒 - 挂起时间: %s秒 - 结果集数: %s - 扫描行数: %s | %s\n", timestamp, query_time, lock_time, rows_send, rows_examined, sql)
    }

}
```