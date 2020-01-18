DROP TABLE IF EXISTS ods_wefix.user_info_tsv;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_wefix.user_info_tsv (
  `user_id`         string  COMMENT '用户编号',
  `email`           string  COMMENT '用户邮箱',
  `nick_name`       string  COMMENT '用户昵称',
  `password`        string  COMMENT '用户密码',
  `sex`             string  COMMENT '用户性别',
  `active_status`   int     COMMENT '用户激活状态',
  `status`          int     COMMENT '用户状态',
  `role`            int     COMMENT '角色',
  `create_time`     string  COMMENT '用户创建时间',
  `update_time`     string  COMMENT '用户更新时间',
  `flow_id`         string  COMMENT '用户公司编号',
  `mobile`          string  COMMENT '用户手机号',
  `company`         string  COMMENT '用户公司名称',
  `rights`          int     COMMENT '拥有的权益（2进制）：第1位atd：1、开通，0、未开通',
  `login_time`      string  COMMENT '用户登录时间'
) COMMENT '用户信息表'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_wefix.db/user_info_tsv';
