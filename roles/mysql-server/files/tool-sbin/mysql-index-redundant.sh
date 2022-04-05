#!/usr/bin/env bash
# 检查冗余索引的情况
# 作者: 应卓

sql="
SELECT
	r.table_schema AS 'database',
	r.table_name AS 'table',
	r.redundant_index_name,
	r.redundant_index_columns,
	r.dominant_index_name,
	r.dominant_index_columns
FROM
	sys.schema_redundant_indexes AS r
WHERE
	r.table_schema NOT IN ( 'mysql', 'information_schema', 'performance_schema', 'sys', 'zabbix' );
"

mysql -e "$sql" | awk '
BEGIN {
  count = 0
}

NR != 1 {
  printf("[warning] [redundant index] database: %s | table: %s | index-name: %s | index-columns: %s | dominant-index-name: %s | dominant-index-columns: %s \n", $1, $2, $3, $4, $5, $6)
  count ++
}

END {
  if (count != 0) {
    printf("[warning] [redundant index] total: %d\n", count)
  }
}
'
