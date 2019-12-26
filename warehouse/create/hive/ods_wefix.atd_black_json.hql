DROP TABLE IF EXISTS ods_wefix.atd_black_json;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_wefix.atd_black_json(
  `waterId`     bigint    COMMENT '请求流水Id',
  `time`        string    COMMENT '写入本地时间',
  `type`        string    COMMENT '设备码类型',
  `id`          string    COMMENT '设备id',
  `exId`        int       COMMENT 'exchangeId',
  `AppId`       string    COMMENT 'AppId',
  `planId`      bigint    COMMENT '获客计划Id',
  `status`      int       COMMENT '请求状态：0、租户请求WeFix但不请求TD，1、租户请求WeFix但请求TD',
  `fLevel`      string    COMMENT '拦截级别',
  `fStatus`     int       COMMENT '0、通过，1、已拦截',
  `inBlackList` boolean   COMMENT '是否在黑名单中',
  `tdCode`      int       COMMENT '请求结果状态码'
) COMMENT '设备黑名单'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_wefix.db/atd_black_json';


