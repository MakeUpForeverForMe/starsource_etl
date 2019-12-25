-- DROP TABLE IF EXISTS ods_source.flow_record_json;
-- DROP TABLE IF EXISTS ods_source.flow_record;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_source.flow_record_json(
  `_id` string COMMENT '主键id',
  outerOrderId string COMMENT '外部订单号',
  adsState int COMMENT '流量状态：1表示有效，-1表示无效',
  code  String COMMENT '错误类型，详情参见ReturnCode',
  msg String COMMENT '错误信息',
  planId string COMMENT '获客计划编号',
  clientId string COMMENT '客户编号',
  cTime string COMMENT '创建时间',
  uTime string COMMENT '更新时间',
  isNewClient int COMMENT '是否新用户 0为老用户，1新用户',
  name string COMMENT '客户姓名',
  idCard string COMMENT '身份证编号',
  mobile string COMMENT '手机号',
  ipadress string COMMENT 'ip地址',
  birthdate string COMMENT '出生日期',
  sex int COMMENT '性别',
  province string COMMENT '省份',
  city string COMMENT '城市',
  expectation double COMMENT '申请金额/万',
  age int COMMENT '年龄',
  wagePayment int COMMENT '工资发放形式',
  haveHouse int COMMENT '是否有房',
  haveCar int COMMENT '是否有车',
  accumulationfund int COMMENT '是否有公积金',
  insure int COMMENT '是否有保险',
  creditCard int COMMENT '是否有信用卡',
  weiLiDai int COMMENT '是否有微粒贷',
  zmCredit string COMMENT '芝麻信用分',
  fChannel string COMMENT '流量方一级子渠道',
  sChannel string COMMENT '流量方二级子渠道',
  tChannel string COMMENT '流量方三级子渠道',
  sourceChannel string COMMENT '流量方渠道标签',
  enableRealName boolean COMMENT '是否完成实名认证',
  enableBankCard boolean COMMENT '是否完成银行卡认证',
  enableCarrier boolean COMMENT '是否完成运营商认证',
  enableEcommerce boolean COMMENT '是否完成电商认证'
) COMMENT '客户信息流水表'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_source.db/flow_record_json';

