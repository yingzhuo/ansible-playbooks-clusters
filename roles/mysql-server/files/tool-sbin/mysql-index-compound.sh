#!/usr/bin/env bash
# 检查复合索引的使用情况
# 作者: 应卓

sql="
SELECT DISTINCT
	s.TABLE_SCHEMA,
	s.TABLE_NAME,
	s.INDEX_NAME
FROM
	information_schema.STATISTICS AS s
WHERE
	s.TABLE_SCHEMA NOT IN ( 'mysql', 'information_schema', 'performance_schema', 'sys', 'zabbix' )
	AND s.SEQ_IN_INDEX <> 1
"

mysql -e "$sql" | awk '
BEGIN {
  count = 0
}

NR != 1 {
  printf("[info] [compound index] database: %s | table: %s | index: %s\n", $1, $2, $3)
  count ++
}

END {
  if (count != 0) {
    printf("[info] [compound index] total: %d\n", count)
  }
}
'
