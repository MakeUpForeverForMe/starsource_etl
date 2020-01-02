DROP TABLE IF EXISTS dm_cf.data_preference;

CREATE TABLE IF NOT EXISTS dm_cf.data_preference (
  `report_date` string  COMMENT '报告日期',
  `app_name`    string  COMMENT '应用名称',
  `apply_cnt`   string  COMMENT '换量申请次数',
  `change_cnt`  string  COMMENT '换量次数'
) COMMENT '偏好数据'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
STORED AS PARQUET
TBLPROPERTIES('PARQUET.COMPRESSION'='SNAPPY');
