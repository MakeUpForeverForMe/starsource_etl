DROP TABLE IF EXISTS `ADDITION_OVERVIEW`;


CREATE TABLE IF NOT EXISTS `ADDITION_OVERVIEW` (
  `id`            bigint(20)  NOT NULL  AUTO_INCREMENT              COMMENT '主键',
  `ctime`         datetime    NOT NULL  DEFAULT CURRENT_TIMESTAMP() COMMENT '插入时间',
  `create_date`   date        NOT NULL  DEFAULT '2019-01-01'        COMMENT '创建日期',
  `cnt_usr`       bigint(20)  NOT NULL  DEFAULT 0                   COMMENT '新增注册',
  `cnt_app`       bigint(20)  NOT NULL  DEFAULT 0                   COMMENT '新增App数',
  `cnt_adv`       bigint(20)  NOT NULL  DEFAULT 0                   COMMENT '新增广告位',
  `cnt_pln`       bigint(20)  NOT NULL  DEFAULT 0                   COMMENT '新增获客计划',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unity_index` (`create_date`) USING BTREE  COMMENT '唯一索引，用于去重'
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT '新增概览';


