-- DROP TABLE IF EXISTS ods_wefix.app_info_tsv;


CREATE EXTERNAL TABLE IF NOT EXISTS ods_wefix.app_info_tsv(
  `app_id`        string  COMMENT '用户Id',
  `app_name`      string  COMMENT '应用名称',
  `flow_id`       string  COMMENT '流量方',
  `system`        string  COMMENT '操作系统',
  `app_type`      string  COMMENT '应用分类',
  `type`          int     COMMENT '应用类型',
  `device_type`   int     COMMENT '终端类型',
  `bundle`        string  COMMENT '应用唯一标识: com.weshare.app',
  `down_url`      string  COMMENT '下载链接',
  `tags`          string  COMMENT '应用标签',
  `dau`           string  COMMENT '日活数',
  `crowd`         string  COMMENT '人群',
  `description`   string  COMMENT '描述',
  `create_time`   string  COMMENT '创建时间',
  `update_time`   string  COMMENT '修改时间',
  `status`        int     COMMENT '状态:  1上线  2 下线  3 审核中',
  `online_time`   string  COMMENT '上线时间',
  `outline_time`  string  COMMENT '下线时间',
  `user_id`       string  COMMENT '用户Id',
  `app_desc`      string  COMMENT 'app描述，如C轮融资等',
  `company_id`    int     COMMENT '公司编号',
  `logo_url`      string  COMMENT '应用logoUrl'
) COMMENT '应用信息表'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/warehouse/tablespace/managed/hive/ods_wefix.db/app_info_tsv';
