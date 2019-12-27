-- DROP TABLE IF EXISTS `UNFRAUD_RECOMMEND_WEFIX`;
DROP TABLE IF EXISTS `ADT_ADMIN`;

CREATE TABLE IF NOT EXISTS `ADT_ADMIN` (
  `id`              int(11)     NOT     NULL AUTO_INCREMENT COMMENT '主键',
  `create_time`     datetime    DEFAULT CURRENT_TIMESTAMP() COMMENT '插入数据时间(2020-01-01 00:00:00)',
  `report_date`     date        DEFAULT NULL                COMMENT '拦截日期',
  `login_appname`   varchar(64) DEFAULT NULL                COMMENT '登陆者应用',
  `login_advname`   varchar(64) DEFAULT NULL                COMMENT '登陆者广告位',
  `viewer_appname`  varchar(64) DEFAULT NULL                COMMENT '展示者应用',
  `viewer_advname`  varchar(64) DEFAULT NULL                COMMENT '展示者广告位',
  `status_b`        int(11)     DEFAULT NULL                COMMENT '黑名单请求状态',
  `flevel_b`        varchar(64) DEFAULT NULL                COMMENT '黑名单拦截级别',
  `fstatus_b`       int(11)     DEFAULT NULL                COMMENT '黑名单拦截状态',
  `inblacklist`     varchar(64) DEFAULT NULL                COMMENT '黑名单风险程度',
  `cnt_b`           int(11)     DEFAULT NULL                COMMENT '黑名单拦截数',
  `status_d`        int(11)     DEFAULT NULL                COMMENT '设备请求状态',
  `flevel_d`        varchar(64) DEFAULT NULL                COMMENT '设备拦截级别',
  `fstatus_d`       int(11)     DEFAULT NULL                COMMENT '设备拦截状态',
  `quality_d`       varchar(64) DEFAULT NULL                COMMENT '设备风险程度',
  `cnt_d`           int(11)     DEFAULT NULL                COMMENT '设备拦截数',
  `status_i`        int(11)     DEFAULT NULL                COMMENT '网段请求状态',
  `flevel_i`        varchar(64) DEFAULT NULL                COMMENT '网段拦截级别',
  `fstatus_i`       int(11)     DEFAULT NULL                COMMENT '网段拦截状态',
  `quality_i`       varchar(64) DEFAULT NULL                COMMENT '网段风险程度',
  `cnt_i`           int(11)     DEFAULT NULL                COMMENT '网段拦截数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unity_index` (`report_date`,`login_advname`,`viewer_advname`,`status_b`,`flevel_b`,`fstatus_b`,`inblacklist`,`status_d`,`flevel_d`,`fstatus_d`,`quality_d`,`status_i`,`flevel_i`,`fstatus_i`,`quality_i`) USING BTREE COMMENT '唯一索引，用于去重'
) ENGINE=MyIsam   AUTO_INCREMENT=1  DEFAULT CHARSET=utf8  COMMENT 'WeFix反欺诈管理员表';
