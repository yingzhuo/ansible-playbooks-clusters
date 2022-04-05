#!/usr/bin/env bash
# 检查低选择度的索引
# 作者: 应卓

sql="
SELECT
	s.TABLE_SCHEMA,
	s.TABLE_NAME,
	s.INDEX_NAME,
	s.CARDINALITY / t.TABLE_ROWS,
	t.TABLE_TYPE,
	s.CARDINALITY,
	t.TABLE_ROWS,
	s.SEQ_IN_INDEX
FROM
	information_schema.STATISTICS AS s
	LEFT JOIN information_schema.TABLES AS t ON t.TABLE_SCHEMA = s.TABLE_SCHEMA
	AND t.TABLE_NAME = s.TABLE_NAME
WHERE
	t.TABLE_SCHEMA NOT IN ( 'mysql', 'information_schema', 'performance_schema', 'sys', 'zabbix' )
	AND s.SEQ_IN_INDEX = 1
	AND s.CARDINALITY / t.TABLE_ROWS < 0.1
"

mysql -e "$sql" | awk '
BEGIN {
  count = 1
}

NR != 1 {
  printf("[warning] [low cardinality index] database: %s | table: %s | index: %s | coefficient: %s\n", $1, $2, $3, $4)
  count ++
}

END {
  if (count != 0) {
    printf("[warning] [low cardinality index] total: %d\n", count)
  }
}
'
