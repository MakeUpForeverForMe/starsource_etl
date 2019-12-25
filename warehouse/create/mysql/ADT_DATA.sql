DROP TABLE IF EXISTS `ADT_DATA`;

CREATE TABLE IF NOT EXISTS `ADT_DATA` (
  `id`              int(11)     NOT NULL AUTO_INCREMENT     COMMENT '主键',
  `create_time`     datetime    DEFAULT CURRENT_TIMESTAMP() COMMENT '插入数据时间(2020-01-01 00:00:00)',
  `report_date`     varchar(8)  NOT NULL                    COMMENT '报告日期(20200101)',
  `login_userId`    varchar(64) DEFAULT NULL                COMMENT '登录者用户ID',
  `login_appId`     varchar(64) DEFAULT NULL                COMMENT '登录者AppID',
  `login_advId`     varchar(64) DEFAULT NULL                COMMENT '登录者广告位ID',
  `viewer_appId`    varchar(64) DEFAULT NULL                COMMENT '展示者AppID',
  `viewer_advId`    varchar(64) DEFAULT NULL                COMMENT '展示者广告位ID',
  `req_sum`         int(11)     DEFAULT 0                   COMMENT '总请求数',
  `blacklist_sum`   int(11)     DEFAULT 0                   COMMENT '进入黑名单的设备数量',
  `sus_device_sum`  int(11)     DEFAULT 0                   COMMENT '可疑设备数量',
  `sus_ip_sum`      int(11)     DEFAULT 0                   COMMENT '可疑IP数量',
  `bl_device_sum`   int(11)     DEFAULT 0                   COMMENT '黑名单&可疑设备数量',
  `bl_ip_sum`       int(11)     DEFAULT 0                   COMMENT '黑名单&可疑IP数量',
  `dvi_ip_sum`      int(11)     DEFAULT 0                   COMMENT '可疑设备&可疑IP数量',
  `bl_dvi_ip_sum`   int(11)     DEFAULT 0                   COMMENT '黑名单&可疑设备&可疑IP数量',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unity_index` (`report_date`,`login_userId`,`login_advId`,`viewer_advId`) USING BTREE COMMENT '唯一索引，用于去重'
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8 COMMENT '反欺诈用户数据概览';
