DROP TABLE IF EXISTS DATA_PREFERENCE;

CREATE TABLE IF NOT EXISTS DATA_PREFERENCE (
  `id`          bigint(20)  NOT NULL  AUTO_INCREMENT              COMMENT '主键',
  `ctime`       datetime    NOT NULL  DEFAULT CURRENT_TIMESTAMP() COMMENT '插入时间',
  `utime`       datetime    NOT NULL  DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `report_date` varchar(8)  NOT NULL      COMMENT '报告日期',
  `app_name`    varchar(64) DEFAULT NULL  COMMENT '应用名称',
  `apply_cnt`   int(11)     DEFAULT 0     COMMENT '换量申请次数',
  `change_cnt`  int(11)     DEFAULT 0     COMMENT '换量次数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unity_index` (`report_date`,`app_name`) USING BTREE  COMMENT '唯一索引，用于去重'
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT '偏好数据';
