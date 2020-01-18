DROP TABLE IF EXISTS dm_cf.retention_overview;


CREATE TABLE IF NOT EXISTS dm_cf.retention_overview (
  `create_date`   string              COMMENT '创建日期',
  `login_date`    string              COMMENT '登录日期',
  `email`         string              COMMENT '用户邮箱',
  `mobile`        string              COMMENT '用户手机',
  `apps`          map<string,string>  COMMENT '创建应用',
  `year_month`    string              COMMENT '年月',
  `day_of_month`  string              COMMENT '天'
) COMMENT '留存概览'
STORED AS PARQUET
TBLPROPERTIES('PARQUET.COMPRESSION'='SNAPPY');
