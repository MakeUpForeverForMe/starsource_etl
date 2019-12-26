DROP TABLE IF EXISTS dm_cf.adt_admin;


CREATE TABLE IF NOT EXISTS dm_cf.adt_admin(
  `report_date`     string  COMMENT '拦截日期',
  `login_appname`   string  COMMENT '登陆者应用',
  `login_advname`   string  COMMENT '登陆者广告位',
  `viewer_appname`  string  COMMENT '展示者应用',
  `viewer_advname`  string  COMMENT '展示者广告位',
  `status_b`        int     COMMENT '黑名单请求状态',
  `flevel_b`        string  COMMENT '黑名单拦截级别',
  `fstatus_b`       int     COMMENT '黑名单拦截状态',
  `inblacklist`     boolean COMMENT '黑名单风险程度',
  `cnt_b`           int     COMMENT '黑名单拦截数',
  `status_d`        int     COMMENT '设备请求状态',
  `flevel_d`        string  COMMENT '设备拦截级别',
  `fstatus_d`       int     COMMENT '设备拦截状态',
  `quality_d`       string  COMMENT '设备风险程度',
  `cnt_d`           int     COMMENT '设备拦截数',
  `status_i`        int     COMMENT '网段请求状态',
  `flevel_i`        string  COMMENT '网段拦截级别',
  `fstatus_i`       int     COMMENT '网段拦截状态',
  `quality_i`       string  COMMENT '网段风险程度',
  `cnt_i`           int     COMMENT '网段拦截数'
) COMMENT 'WeFix反欺诈管理员表'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
STORED AS PARQUET
TBLPROPERTIES('PARQUET.COMPRESSION'='SNAPPY');
