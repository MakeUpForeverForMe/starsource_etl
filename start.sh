#!/bin/bash

. $(dirname "${BASH_SOURCE[0]}")/lib/env.sh

# 获取日志信息传入到error日志中
erro_log &

# 抽取数据


sh $bin/1extract.sh

# sh $bin/0_1add_part.sh

# sh $bin/2load_hdfs.sh

# sh $bin/3data_transform.sh

# sh $bin/4export_to_mysql.sh


# 服务器测试
ps -ef | grep -v grep | grep -Ew 'tail -F -n 0' | awk '{print $2}' | xargs kill

