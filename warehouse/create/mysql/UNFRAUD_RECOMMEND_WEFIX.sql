DROP TABLE IF EXISTS `UNFRAUD_RECOMMEND_WEFIX`;

CREATE TABLE IF NOT EXISTS `UNFRAUD_RECOMMEND_WEFIX` (
  `id`          int(11)     NOT     NULL AUTO_INCREMENT COMMENT '主键',
  `report_date` date        NOT     NULL                COMMENT '报告日期',
  `app_name`    varchar(64) DEFAULT NULL                COMMENT 'AppID',
  `blacklist`   int(11)     DEFAULT NULL                COMMENT '进入黑名单的设备数量',
  `request_sum` int(11)     DEFAULT NULL                COMMENT '合计请求数',
  `device_exce` int(11)     DEFAULT NULL                COMMENT '设备评级数(优)',
  `device_good` int(11)     DEFAULT NULL                COMMENT '设备评级数(良)',
  `device_gene` int(11)     DEFAULT NULL                COMMENT '设备评级数(一般)',
  `device_diff` int(11)     DEFAULT NULL                COMMENT '设备评级数(差)',
  `device_erro` int(11)     DEFAULT NULL                COMMENT '设备评级数(error)',
  `iprate_exce` int(11)     DEFAULT NULL                COMMENT 'IP评级数(正常)',
  `iprate_gene` int(11)     DEFAULT NULL                COMMENT 'IP评级数(一般)',
  `iprate_diff` int(11)     DEFAULT NULL                COMMENT 'IP评级数(可疑)',
  `iprate_erro` int(11)     DEFAULT NULL                COMMENT 'IP评级数(error)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unity_index` (`report_date`,`app_name`) USING BTREE COMMENT '唯一索引，用于去重'
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT 'WeFix反欺诈与推荐管理员表';
