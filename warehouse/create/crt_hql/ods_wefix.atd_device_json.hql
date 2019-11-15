-- DROP TABLE IF EXISTS ods_wefix.atd_device_json;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_wefix.atd_device_json(
  `time` string COMMENT '写入本地时间',
  `type` string COMMENT '设备码类型',
  `id` string COMMENT '设备id',
  `AppId` String COMMENT 'AppId',
  `quality` string COMMENT '设备风险程度（优，良，一般，差）'
) COMMENT '设备风险程度'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_wefix.db/atd_device_json';
