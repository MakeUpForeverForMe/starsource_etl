-- DROP TABLE IF EXISTS ods_wefix.atd_black_json;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_wefix.atd_black_json(
  `time` string COMMENT '写入本地时间',
  `type` string COMMENT '设备码类型',
  `id` string COMMENT '设备id',
  `appId` String COMMENT 'AppId',
  `inBlackList` boolean COMMENT '是否在黑名单中'
) COMMENT '设备黑名单'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_wefix.db/atd_black_json';
