DROP TABLE IF EXISTS RETENTION_OVERVIEW;

CREATE TABLE IF NOT EXISTS RETENTION_OVERVIEW (
  `id`          bigint(20)    NOT NULL  AUTO_INCREMENT              COMMENT '主键',
  `ctime`       datetime      NOT NULL  DEFAULT CURRENT_TIMESTAMP() COMMENT '插入时间',
  `create_date` date          NOT NULL  DEFAULT '2019-01-01'        COMMENT '创建日期',
  `login_date`  date          NOT NULL  DEFAULT '2019-01-01'        COMMENT '登录日期',
  `email`       varchar(64)   DEFAULT NULL                          COMMENT '用户邮箱',
  `mobile`      varchar(64)   DEFAULT NULL                          COMMENT '用户手机',
  `apps`        varchar(255)  DEFAULT NULL                          COMMENT '创建应用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unity_index` (`create_date`,`email`,`mobile`) USING BTREE  COMMENT '唯一索引，用于去重'
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT '留存概览';


