#!/usr/bin/env bash
# 检查不使用"utf8mb4"字符集的列
# 作者: 应卓

sql="
SELECT
	TABLE_SCHEMA,
	TABLE_NAME,
	COLUMN_NAME,
	CHARACTER_SET_NAME,
	COLLATION_NAME
FROM
	information_schema.COLUMNS
WHERE
	TABLE_SCHEMA NOT IN ('mysql', 'information_schema', 'performance_schema', 'sys', 'zabbix')
AND
(
	CHARACTER_SET_NAME <> 'utf8mb4'
OR
	COLLATION_NAME <> 'utf8mb4_bin'
)
"

mysql -e "$sql" | awk '
BEGIN {
  count = 0
}

NR != 1 {
  printf("[warning] [non utf8mb4 column] database: %s | table: %s | column: %s | character-set: %s | collation: %s\n", $1, $2, $3, $4, $5)
  count ++
}

END {
  if (count != 0) {
    printf("[warning] [non utf8mb4 column] total: %d\n", count)
  }
}
'
