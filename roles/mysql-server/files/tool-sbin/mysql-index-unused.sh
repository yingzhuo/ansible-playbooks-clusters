#!/usr/bin/env bash
# 检查没使用的索引
# 作者: 应卓

sql="
SELECT
	un.object_schema AS 'schema_name',
	un.object_name AS 'table_name',
	un.index_name AS 'index_name'
FROM
	sys.schema_unused_indexes AS un
WHERE
	un.object_schema NOT IN ( 'mysql', 'information_schema', 'performance_schema', 'sys', 'zabbix' );
"

mysql -e "$sql" | awk '
BEGIN {
  count = 0
}

NR != 1 {
  printf("[warning] [unused index] database: %s | table: %s | index: %s\n", $1, $2, $3)
  count ++
}

END {
  if (count != 0) {
    printf("[warning] [unused index] total: %d\n", count)
  }
}
'
