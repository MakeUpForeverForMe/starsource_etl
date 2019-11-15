-- DROP TABLE IF EXISTS ods_wefix.atd_ip_json;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_wefix.atd_ip_json(
  `time` string COMMENT '写入本地时间',
  `ip` string COMMENT 'IP地址',
  `AppId` String COMMENT 'AppId',
  `quality` string COMMENT 'IP的风险程度（正常，一般，可疑）'
) COMMENT '展示点击流水表'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_wefix.db/atd_ip_json';
