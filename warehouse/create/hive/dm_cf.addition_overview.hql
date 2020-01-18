DROP TABLE IF EXISTS dm_cf.addition_overview;


CREATE TABLE IF NOT EXISTS dm_cf.addition_overview (
  `create_date`   string              COMMENT '创建日期',
  `cnt_usr`       string              COMMENT '新增注册',
  `cnt_app`       string              COMMENT '新增App数',
  `cnt_adv`       string              COMMENT '新增广告位',
  `cnt_pln`       string              COMMENT '新增获客计划',
  `year_month`    string              COMMENT '年月',
  `day_of_month`  string              COMMENT '天'
) COMMENT '新增概览'
STORED AS PARQUET
TBLPROPERTIES('PARQUET.COMPRESSION'='SNAPPY');
