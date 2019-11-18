-- DROP TABLE IF EXISTS ods_wefix.t_ad_query_water_json;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_wefix.t_ad_query_water_json(
  id int COMMENT '流水id',
  reqTime string COMMENT '落盘时间',
  createTime string COMMENT '落库时间',
  requestId string COMMENT '请求方流水Id',
  flowId string COMMENT '机构唯一ID',
  sourceId string COMMENT '数据来源id',
  tagId string COMMENT '广告位Id',
  device struct<
    id_type:string COMMENT '设备码类型，比如：imei/idfa(最大64位)',
    id:string COMMENT '识别设备唯一键，比如：imei/idfa值(最大64位)',
    ipv4:string COMMENT '设备IP',
    type:int COMMENT '设备类型：0-未知、1-android、2-IOS、3-winphone、4其他',
    make:string COMMENT '设备厂商',
    brand:string COMMENT '设备厂商品牌',
    model:string COMMENT '设备型号',
    os:string COMMENT '操作系统',
    osv:string COMMENT '系统版本',
    w:int COMMENT '屏宽',
    h:int COMMENT '屏高',
    carrier:string COMMENT '运营商',
    network:int COMMENT '网络类型：0-wifi、1-4G、2-3G、3-2G',
    geo:struct<
      lat:double COMMENT '纬度',
      lon:double COMMENT '经度'
    > COMMENT '地理位置'
  > COMMENT '设备信息',
  `time` string COMMENT '请求时间',
  city string COMMENT '城市字段',
  acquisitionId String COMMENT '获客计划id',
  productId int COMMENT '产品Id',
  sproductId string COMMENT '产品Id',
  ext string COMMENT '扩展字段'
) COMMENT '请求下发流水表'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_wefix.db/t_ad_query_water_json';
