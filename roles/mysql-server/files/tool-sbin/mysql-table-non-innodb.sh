#!/usr/bin/env bash
# 检查不使用"InnoDB"引擎的表
# 作者: 应卓

sql="
  SELECT
  	TABLE_SCHEMA,
  	TABLE_NAME,
  	ENGINE,
  	FORMAT_BYTES(DATA_LENGTH) AS DATA_SIZE
  FROM
  	information_schema.TABLES
  WHERE
  	TABLE_SCHEMA NOT IN ('mysql', 'information_schema', 'performance_schema', 'sys', 'zabbix')
  AND
  	ENGINE <> 'InnoDB';
"

mysql -e "$sql" | awk '
BEGIN {
  count = 0
}

NR != 1 {
  printf("[warning] [non innodb table] database: %s | table: %s | size: %s kB \n", $1, $2, $4)
  count ++
}

END {
  if (count != 0) {
    printf("[warning] [non innodb table] total: %d \n", count)
  }
}
'
