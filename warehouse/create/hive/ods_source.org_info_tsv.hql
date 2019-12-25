-- DROP TABLE IF EXISTS ods_source.org_info_tsv;
-- DROP TABLE IF EXISTS ods_source.org_info;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_source.org_info_tsv(
  `_id` int COMMENT '公司编号',
  company_name string COMMENT '公司名称',
  fax_no string COMMENT '公司传真',
  phone string COMMENT '公司电话',
  address string COMMENT '公司地址',
  status int COMMENT '状态:0禁止,1启用',
  has_concact_info int COMMENT '是否同步管理员信息:0否,1是',
  concact_name string COMMENT '联系人姓名',
  concact_phone string COMMENT '联系人电话',
  concact_email string COMMENT '联系人邮箱',
  create_user_id int COMMENT '创建人id',
  update_user_id int COMMENT '更新人id',
  create_time string COMMENT '创建时间',
  update_time string COMMENT '更新时间',
  creator string COMMENT '创建人',
  create_by string COMMENT '创建人账号',
  updater string COMMENT '修改人',
  update_by string COMMENT '修改人账号'
) COMMENT '机构方信息表'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_source.db/org_info_tsv';

