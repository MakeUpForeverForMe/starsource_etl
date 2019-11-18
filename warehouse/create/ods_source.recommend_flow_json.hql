-- DROP TABLE IF EXISTS ods_source.recommend_flow_json;
-- DROP TABLE IF EXISTS ods_source.recommend_flow;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_source.recommend_flow_json(
  `_id` string COMMENT '主键',
  clientId string COMMENT '客户编号',
  planId string COMMENT '获客计划编号',
  productId string COMMENT '产品编号',
  wOrderId string COMMENT '定单编号',
  sourceId string COMMENT '流量编号',
  productPrice double COMMENT '产品单价',
  fChannel string COMMENT '流量方一级子渠道',
  sChannel string COMMENT '流量方二级子渠道',
  tChannel string COMMENT '流量方三级子渠道',
  cTime string COMMENT '创建时间',
  uTime string COMMENT '更新时间',
  code int COMMENT '错误编码',
  msg string COMMENT '错误信息:成功为空',
  exclusive boolean COMMENT '是否独家'
) COMMENT '推送信息表'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_source.db/recommend_flow_json';

