-- DROP TABLE IF EXISTS ods_source.client_info_json;
-- DROP TABLE IF EXISTS ods_source.client_info;



CREATE EXTERNAL TABLE IF NOT EXISTS ods_source.client_info_json(
  `_id` string COMMENT '客户编号',
  name string COMMENT '客户姓名',
  idCard string COMMENT '身份证编号',
  mobile string COMMENT '手机号',
  cTime string COMMENT '创建时间',
  uTime string COMMENT '更新时间',
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
  intersectionTags Array<int> COMMENT '互斥标签',
  unionTags Array<int> COMMENT '特征标签，可以有多个',
  enableRealName boolean COMMENT '是否完成实名认证',
  enableBankCard boolean COMMENT '是否完成银行卡认证',
  enableCarrier boolean COMMENT '是否完成运营商认证',
  enableEcommerce boolean COMMENT '是否完成电商认证'
) COMMENT '客户信息表'
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_source.db/client_info_json';

