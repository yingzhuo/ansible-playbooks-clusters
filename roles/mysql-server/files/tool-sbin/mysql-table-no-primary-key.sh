#!/usr/bin/env bash
# 检查mysql实例中没有主键的表
# 作者: 应卓

sql="
SELECT
	t.TABLE_SCHEMA,
	t.TABLE_NAME
FROM
	information_schema.TABLES AS t
	LEFT JOIN information_schema.TABLE_CONSTRAINTS AS tco ON tco.TABLE_SCHEMA = t.TABLE_SCHEMA
	AND tco.TABLE_NAME = t.TABLE_NAME
	AND tco.CONSTRAINT_TYPE = 'PRIMARY KEY'
WHERE
	t.TABLE_SCHEMA NOT IN ('mysql', 'information_schema', 'performance_schema', 'sys', 'zabbix')
	AND t.TABLE_TYPE = 'BASE TABLE'
	AND tco.CONSTRAINT_TYPE IS NULL
ORDER BY
	t.TABLE_SCHEMA,
	t.TABLE_NAME;
"

mysql -e "$sql" | awk '
BEGIN {
  count = 0
}

NR != 1 {
  printf("[warning] [table without primary key] database: %s | table: %s\n", $1, $2)
  count ++
}

END {
  if (count != 0) {
    printf("[warning] [table without primary key] total: %d\n", count)
  }
}
'
