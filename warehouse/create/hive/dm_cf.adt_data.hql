DROP TABLE IF EXISTS dm_cf.adt_data;

CREATE TABLE IF NOT EXISTS dm_cf.adt_data (
  `report_date`     string  COMMENT '报告日期(20200101)',
  `login_userId`    string  COMMENT '登录者用户ID',
  `login_appId`     string  COMMENT '登录者AppID',
  `login_advId`     string  COMMENT '登录者广告位ID',
  `viewer_appId`    string  COMMENT '展示者AppID',
  `viewer_advId`    string  COMMENT '展示者广告位ID',
  `req_sum`         int     COMMENT '总请求数',
  `blacklist_sum`   int     COMMENT '进入黑名单的设备数量',
  `sus_device_sum`  int     COMMENT '可疑设备数量',
  `sus_ip_sum`      int     COMMENT '可疑IP数量',
  `bl_device_sum`   int     COMMENT '黑名单&可疑设备数量',
  `bl_ip_sum`       int     COMMENT '黑名单&可疑IP数量',
  `dvi_ip_sum`      int     COMMENT '可疑设备&可疑IP数量',
  `bl_dvi_ip_sum`   int     COMMENT '黑名单&可疑设备&可疑IP数量'
) COMMENT '反欺诈用户数据概览'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
STORED AS PARQUET
TBLPROPERTIES('PARQUET.COMPRESSION'='SNAPPY');
