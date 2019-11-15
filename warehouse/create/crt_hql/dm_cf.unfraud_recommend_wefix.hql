-- DROP TABLE IF EXISTS dm_cf.unfraud_recommend_wefix;


CREATE TABLE IF NOT EXISTS dm_cf.unfraud_recommend_wefix(
  `report_date` string  COMMENT '报告日期',
  `app_id`      string  COMMENT 'AppId',
  `blacklist`   int     COMMENT '进入黑名单的数量',
  `request_sum` int     COMMENT '合计请求数',
  `device_exce` int     COMMENT '设备评级数(优)',
  `device_good` int     COMMENT '设备评级数(良)',
  `device_gene` int     COMMENT '设备评级数(一般)',
  `device_diff` int     COMMENT '设备评级数(差)',
  `device_erro` int     COMMENT '设备评级数(error)',
  `iprate_exce` int     COMMENT 'IP评级数(正常)',
  `iprate_gene` int     COMMENT 'IP评级数(一般)',
  `iprate_diff` int     COMMENT 'IP评级数(可疑)',
  `iprate_erro` int     COMMENT 'IP评级数(error)'
) COMMENT 'WeFix反欺诈与推荐管理员表'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
STORED AS PARQUET
TBLPROPERTIES('PARQUET.COMPRESSION'='SNAPPY');
