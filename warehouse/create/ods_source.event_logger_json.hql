-- DROP TABLE IF EXISTS ods_source.event_logger_json;
-- DROP TABLE IF EXISTS ods_source.event_logger;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_source.event_logger_json(
  `_id` string COMMENT '自增id',
  orderId string COMMENT '渠道方订单号',
  cTime string COMMENT '时间',
  sourceChannel string COMMENT '流量方渠道标签',
  eventType int COMMENT '事件类型',
  clientId string COMMENT '客户编号'
) COMMENT '事件信息流水表'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_source.db/event_logger_json';

