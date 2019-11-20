#!/bin/bash -e

. /etc/profile
. ~/.bash_profile
. $(dirname "${BASH_SOURCE[0]}")/lib.sh


# 采用"${BASH_SOURCE[0]}"是因为在source时，拿到的是自己本身的路径
# 如：在test.sh中添加了. ./env.sh
# 如果env.sh中是使用$(basename $0)作为变量值。则执行test.sh时，dirname拿到的是test.sh的路径
# 如果env.sh中是使用$(basename "${BASH_SOURCE[0]}")作为变量值。则执行test.sh时，dirname拿到的是env.sh的路径
base_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
env_file=$base_dir/$(basename "${BASH_SOURCE[0]}")






# ---------------===============>>>>>>>>>>>>>>>          允许修改          <<<<<<<<<<<<<<<===============--------------- #

# 并行数
p_num=20
# HDFS主目录
hdfs_path=/warehouse/tablespace/managed/hive
# 本地数据存储目录
data_direct=/hadoop/data
# 数仓层次
ware_level=(dm)
# 初始化时间
# 2019-01-01 00:00:00   2019-10-01 00:00:00   2019-11-01 00:00:00
# init_time=1546272000  init_time=1569859200  init_time=1572537600
init_time=1546272000
# 删除分区距今天时长【day:30,mongth:12,year:2】
dele_part=year:2
# 打包限定时间
unpack_time=1216


# ----------==========>>>>>>>>>>          命令配置          <<<<<<<<<<==========---------- #
# beeline命令位置
beeline_home=beeline
# hive用户
beeline_user=hdfs
# hiveServer2服务器ip
beeline_host=spark
# hiveServer2服务端口
beeline_port=10000
# jdbc远程连接url
beeline_url=jdbc:hive2://$beeline_host:$beeline_port
# beeline远程连接
beeline="$beeline_home -u $beeline_url -n $beeline_user"







# ---------------===============>>>>>>>>>>>>>>>          不可修改          <<<<<<<<<<<<<<<===============--------------- #

# ----------==========>>>>>>>>>>          基础信息          <<<<<<<<<<==========---------- #
# 执行机器
host_name=$(hostname)
# 执行用户
user_name=$(whoami)



# ----------==========>>>>>>>>>>          目录配置          <<<<<<<<<<==========---------- #
# 函数库目录      # 操作配置目录              # 操作命令目录
lib=$base_dir     conf=$base_dir/../conf      bin=$base_dir/../bin
# 配置文件
imex_table=$conf/imex.table
# 执行文件主目录
warehouse=$base_dir/../warehouse
# 存储导入MySQL数据的目录
mysql_dir=$data_direct/mysql


# ----------==========>>>>>>>>>>          时间配置          <<<<<<<<<<==========---------- #
# 当前时间/秒
n_time=$(curr_time)
# 当前的年月
yearmonth=$(s_d ym $n_time)
# 两月之前的年月
yearmonth_last_2=$(s_d -d '-2' -f month ym $n_time)
# 当前的天和小时
dayhour=$(s_d dh)


# ----------==========>>>>>>>>>>          日志配置          <<<<<<<<<<==========---------- #
# info日志文件 带有当年的年月时间目录
info_log=${data_direct}/info.log.${yearmonth}
# erro日志文件
erro_log=${data_direct}/erro.log.${yearmonth}







