#!/bin/bash

. $(dirname "${BASH_SOURCE[0]}")/lib/env.sh


info_start='Start File'

info "$info_start" '开始文件执行开始' >> $info_log


# 获取日志信息传入到error日志中
erro_log >> $info_log &

# 抽取数据

[[ $(s_d h $n_time) == 00 ]] && sh $bin/0_add_part.sh &>> $info_log


sh $bin/1_extract.sh &>> $info_log

sh $bin/2_load_hdfs.sh &>> $info_log

sh $bin/3_data_transform.sh &>> $info_log

sh $bin/4_export_to_mysql.sh &>> $info_log


# 服务器测试
ps -ef | grep -v grep | grep -Ew 'tail -F -n 0' | awk '{print $2}' | xargs kill >> $info_log


info "$info_start" '开始文件执行结束' >> $info_log
