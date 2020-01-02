DROP TABLE IF EXISTS ods_wefix.exchange_info_child_tsv;


CREATE TABLE IF NOT EXISTS ods_wefix.exchange_info_child_tsv (
  `exchange_child_id`   int     COMMENT '子交换信息id',
  `audit_app_id`        string  COMMENT '审核人AppId',
  `audit_adver_id`      string  COMMENT '申请人申请审核人所拥有的广告位Id',
  `audit_plan_id`       string  COMMENT '审核人提供获客计划Id',
  `apply_app_id`        string  COMMENT '申请人AppId',
  `apply_plan_id`       string  COMMENT '申请人提供获客计划Id',
  `apply_adver_id`      string  COMMENT '审核人申请申请人所拥有的广告位',
  `status`              int     COMMENT '1、申请人已申请，2、审核人审核中，3、审核人审核不通过，4、审核人审核通过，5、申请人审核中，6、申请人审核不通过，7、流量交换开始，8、审核人暂停流量交换，9、申请人暂停流量交换，10、申请人停止流量交换，11、审核人停止流量交换，12、系统停止，13、申请人审核通过，14、待生效（生效变为7），999、删除',
  `create_time`         string  COMMENT '申请时间',
  `audit_time`          string  COMMENT '审核时间',
  `apply_user_id`       string  COMMENT '申请人id',
  `audit_user_id`       string  COMMENT '审核人id',
  `update_time`         string  COMMENT '修改时间(当前版本暂时无用)',
  `operate_status`      int     COMMENT '操作类型：1、广告位停止，2、获客计划停止',
  `exchange_parent_id`  int     COMMENT '父交换信息id'
) COMMENT '流量交换申请记录子表'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_wefix.db/exchange_info_child_tsv';
