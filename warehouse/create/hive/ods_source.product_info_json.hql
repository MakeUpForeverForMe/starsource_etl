-- DROP TABLE IF EXISTS ods_source.product_info_json;
-- DROP TABLE IF EXISTS ods_source.product_info;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_source.product_info_json(
  `_id`             string             COMMENT '产品编号',
  name              string             COMMENT '产品名称',
  description       string             COMMENT '产品简介',
  loanType          int                COMMENT '产品类型',
  loanLimit         int                COMMENT '产品分类',
  mode              int                COMMENT '对接方式',
  loanTime          map<string,string> COMMENT '放款时间',
  loanDeadline      map<string,string> COMMENT '贷款期限',
  logo              string             COMMENT '产品商标',
  redirectUrl       string             COMMENT 'h5机构的跳转url',
  pushUrl           string             COMMENT 'api机构的跳转url',
  pushType          int                COMMENT '主/被动推送',
  notes             string             COMMENT '产品备注',
  cTime             string             COMMENT '创建时间',
  uTime             string             COMMENT '更新时间',
  enableRealName    boolean            COMMENT '线上允许实名认证',
  enableBankCard    boolean            COMMENT '线上允许银行卡',
  enableCarrier     boolean            COMMENT '线上允许运行商',
  enableEcommerce   boolean            COMMENT '线上允许电商',
  tenantId          int                COMMENT '租户id',
  status            int                COMMENT '产品状态',
  signKey           string             COMMENT '签名密码',
  avoidRepeatLimit  int                COMMENT '去重过滤/天',
  delayTime         int                COMMENT '延时分发时间/分',
  delayType         int                COMMENT '延时分发类型:1分 2时 3天',
  `_class`          string             COMMENT '启动类路径',
  className         string             COMMENT 'API机构映射到具体推送类的类名',
  priority          int                COMMENT '优先级'
)                                      COMMENT '产品方信息表'
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_source.db/product_info_json';

