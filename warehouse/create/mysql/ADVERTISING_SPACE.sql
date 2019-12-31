DROP TABLE IF EXISTS ADVERTISING_SPACE;

CREATE TABLE IF NOT EXISTS `ADVERTISING_SPACE` (
  `id`            bigint(20)  NOT NULL AUTO_INCREMENT     COMMENT '主键',
  `create_date`   varchar(16) NOT NULL                    COMMENT '插入日期',
  `report_date`   varchar(8)  NOT NULL                    COMMENT '报告日期',
  `plan_user_id`  varchar(64) DEFAULT NULL                COMMENT '获客计划对应的用户id',
  `plan_app_id`   varchar(64) DEFAULT NULL                COMMENT '获客计划对应的AppID',
  `plan_id`       bigint(64)  DEFAULT 0                   COMMENT '获客计划ID',
  `plan_adv_id`   varchar(64) DEFAULT NULL                COMMENT '获客计划对应的广告位ID',
  `adv_user_id`   varchar(64) DEFAULT NULL                COMMENT '广告位对应的用户id',
  `adv_app_id`    varchar(64) DEFAULT NULL                COMMENT '广告位对应的AppID',
  `adv_id`        varchar(64) DEFAULT NULL                COMMENT '广告位ID',
  `adv_type`      int(1)      DEFAULT 0                   COMMENT '广告位类型',
  `adv_req_num`   int(11)     DEFAULT 0                   COMMENT '广告请求数',
  `adv_iss_num`   int(11)     DEFAULT 0                   COMMENT '广告下发数',
  `iss_req_rate`  double      DEFAULT 0                   COMMENT '下发数与请求数比值',
  `adv_show_num`  int(11)     DEFAULT 0                   COMMENT '广告展示数',
  `adv_show_fail` int(11)     DEFAULT 0                   COMMENT '上报超时数',
  `show_iss_rate` double      DEFAULT 0                   COMMENT '展示数与下发数比值',
  `adv_cli_num`   int(11)     DEFAULT 0                   COMMENT '广告点击数',
  `cli_show_rate` double      DEFAULT 0                   COMMENT '点击数与展示数比值',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unity_index` (`report_date`,`plan_user_id`,`adv_user_id`,`plan_id`,`adv_id`,`plan_adv_id`) USING BTREE  COMMENT '唯一索引，用于去重'
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT 'WeFix置换交易数据概览';
