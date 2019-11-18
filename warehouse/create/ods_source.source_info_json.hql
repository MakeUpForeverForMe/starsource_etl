-- DROP TABLE IF EXISTS ods_source.source_info_json;
-- DROP TABLE IF EXISTS ods_source.source_info;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_source.source_info_json(
  `_id` string COMMENT '流量方编号',
  name string COMMENT '流量方名称',
  description string COMMENT '描述',
  notes string COMMENT '备注',
  price double COMMENT '流量单价',
  duplicateInDays int COMMENT 'x天内视为重复',
  status int COMMENT '流量方状态',
  cTime string COMMENT '创建时间',
  uTime string COMMENT '更新时间',
  sourceMode int COMMENT '对接方式',
  redirectPage int COMMENT '跳转页,配合sourcemode',
  deductionIndex int COMMENT '当前或第二天减量处理比例',
  lastDeductionIndex int COMMENT '上一次的减量处理指标',
  deductionDate string COMMENT '减量日期',
  parentId string COMMENT '上层id,无为null',
  level int COMMENT '层级',
  tenantId int COMMENT '租户id',
  pubKey string COMMENT '公钥',
  priKey string COMMENT '私钥',
  redirectURL string COMMENT '流量方跳转URL',
  callBackURL string COMMENT '流量方回调接口地址',
  `_class` string COMMENT '启动类路径'
) COMMENT '流量方信息表'
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_source.db/source_info_json';

