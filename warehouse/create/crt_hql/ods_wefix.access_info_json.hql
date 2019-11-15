-- DROP TABLE IF EXISTS ods_wefix.access_json;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_wefix.access_json(
  datetime string COMMENT '时间',
  traceid string COMMENT '访问流水',
  url string COMMENT '访问地址',
  acc string COMMENT 'acc(固定值)',
  code string COMMENT '返回code(1或20000表示成功)',
  msg string COMMENT '描述',
  exectime int COMMENT '服务执行时间'
) COMMENT '日志信息表'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_wefix.db/access_json';
