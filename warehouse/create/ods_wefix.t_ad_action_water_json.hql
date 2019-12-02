-- DROP TABLE IF EXISTS ods_wefix.t_ad_action_water_json;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_wefix.t_ad_action_water_json(
  id int COMMENT '主键',
  waterId int COMMENT '流水id',
  deviceId string COMMENT '客户端Id',
  productId int COMMENT '产品Id',
  flowId string COMMENT '机构唯一ID',
  sourceId string COMMENT '数据来源id',
  sspSourceId string COMMENT 'ssp渠道多sourceId',
  createTime string COMMENT '创建时间-bi用',
  createDate string COMMENT '创建时间-ttl专用',
  status  int COMMENT '状态：1、超过展示上报的配置生效时间，0、有效时间上报数据',
  exTagId String COMMENT '交换方广告id',
  display int COMMENT '是否展示：1-展示0、-未展示',
  isClick int COMMENT '是否点击',
  skip int COMMENT '跳过模式：0-没有任何行为、1-人为点击跳过'
) COMMENT '展示点击流水表'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_wefix.db/t_ad_action_water_json';
