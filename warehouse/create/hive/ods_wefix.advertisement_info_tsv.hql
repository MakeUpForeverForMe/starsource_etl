DROP TABLE IF EXISTS ods_wefix.advertisement_info_tsv;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_wefix.advertisement_info_tsv(
  `advertise_id`          string  COMMENT '广告位Id',
  `advertise_name`        string  COMMENT '广告位名称',
  `ctr`                   string  COMMENT '预估点击率',
  `description`           string  COMMENT '描述',
  `flow_type`             int     COMMENT '流量类型',
  `ad_type`               int     COMMENT '广告形式',
  `app_id`                string  COMMENT '应用Id',
  `flow_id`               string  COMMENT '流量方Id',
  `create_time`           string  COMMENT '创建时间',
  `update_time`           string  COMMENT '修改时间',
  `status`                int     COMMENT '状态: 1 上线  2 下线 6 未运行  7运行中',
  `review`                int     COMMENT '状态:  3审核中 4 审核未通过 5未审核 8审核已通过',
  `publish_type`          int     COMMENT '发布类型: 1 已发布  2未发布',
  `apply_time`            string  COMMENT '申请审核时间',
  `display_quantity`      int     COMMENT '预估展示量',
  `top_limit`             int     COMMENT '展示上限',
  `tran_mode`             int     COMMENT '交易模式',
  `shielding_industry`    string  COMMENT '屏蔽的行业',
  `execute_start`         string  COMMENT '执行开始时间',
  `execute_end`           string  COMMENT '执行结束时间',
  `width`                 int     COMMENT '图片的宽',
  `height`                int     COMMENT '图片的高',
  `real_total`            int     COMMENT '当前总数',
  `p_type`                int     COMMENT '广告位分类: 获客  换量',
  `click_rate`            int     COMMENT '点击率',
  `current_exchange_num`  int     COMMENT '当前已交换数量'
) COMMENT '广告位信息表'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_wefix.db/advertisement_info_tsv';
