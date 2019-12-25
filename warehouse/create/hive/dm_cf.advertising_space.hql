DROP TABLE IF EXISTS dm_cf.advertising_space;

CREATE TABLE IF NOT EXISTS dm_cf.advertising_space (
  `create_date`   string  COMMENT '插入日期',
  `report_date`   string  COMMENT '报告日期',
  `plan_user_id`  string  COMMENT '获客计划对应的用户id',
  `plan_app_id`   string  COMMENT '获客计划对应的AppID',
  `plan_id`       bigint  COMMENT '获客计划ID',
  `plan_adv_id`   string  COMMENT '获客计划对应的广告位ID',
  `adv_user_id`   string  COMMENT '广告位对应的用户id',
  `adv_app_id`    string  COMMENT '广告位对应的AppID',
  `adv_id`        string  COMMENT '广告位ID',
  `adv_type`      int     COMMENT '广告位类型',
  `adv_req_num`   int     COMMENT '广告请求数',
  `adv_iss_num`   int     COMMENT '广告下发数',
  `iss_req_rate`  double  COMMENT '下发数与请求数比值',
  `adv_show_num`  int     COMMENT '广告展示数',
  `show_iss_rate` double  COMMENT '展示数与下发数比值',
  `adv_cli_num`   int     COMMENT '广告点击数',
  `cli_show_rate` double  COMMENT '点击数与展示数比值'
) COMMENT 'WeFix置换交易数据概览'
PARTITIONED BY(year_month string COMMENT '年月',day_of_month string COMMENT '天')
STORED AS PARQUET
TBLPROPERTIES('PARQUET.COMPRESSION'='SNAPPY');
