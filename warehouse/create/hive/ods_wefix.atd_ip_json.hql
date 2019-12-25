DROP TABLE IF EXISTS ods_wefix.atd_ip_json;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_wefix.atd_ip_json(
  `waterId` bigint  COMMENT '请求流水Id',
  `time`    string  COMMENT '写入本地时间',
  `ip`      string  COMMENT 'IP地址',
  `exId`    int     COMMENT 'exchangeId',
  `AppId`   string  COMMENT 'AppId',
  `planId`  bigint  COMMENT '获客计划Id',
  `status`  int     COMMENT '请求状态：0、租户请求WeFix但不请求TD，1、租户请求WeFix但请求TD',
  `fLevel`  string  COMMENT '拦截级别',
  `fStatus` bigint  COMMENT '0、通过，1、已拦截',
  `quality` string  COMMENT 'IP的风险程度（正常，一般，可疑）',
  `tdCode`  int     COMMENT '请求结果状态码'
) COMMENT '展示点击流水表'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_wefix.db/atd_ip_json';
