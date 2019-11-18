#!/bin/bash

. $(dirname "${BASH_SOURCE[0]}")/lib/env.sh

# 获取日志信息传入到error日志中
erro_log &

# 抽取数据

sh $bin/0_add_part.sh

sh $bin/1_extract.sh

sh $bin/2_load_hdfs.sh

sh $bin/3_data_transform.sh

sh $bin/4_export_to_mysql.sh


# 服务器测试
ps -ef | grep -v grep | grep -Ew 'tail -F -n 0' | awk '{print $2}' | xargs kill

