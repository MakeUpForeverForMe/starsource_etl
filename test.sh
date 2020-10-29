#!/bin/bash

. /etc/profile
. ~/.bash_profile

# . /home/hdfs/starsource/lib/env.sh
# . $(dirname "${BASH_SOURCE[0]}")/lib/env.sh

# test_arg='1:2:3:4'


# test=$data_direct/ods_source/recommend_flow.201910/recommend_flow.20191022.json


# while [ true ]; do
#   dt=$(date +%s)
#   y=$(date +%Y -d@$dt)
#   m=$(date +%m -d@$dt)
#   d=$(date +%d -d@$dt)
#   h=$(date +%H -d@$dt)
#   t=$(date +%M -d@$dt)
#   s=$(date +%S -d@$dt)
#   n=$(date +%N -d@$dt)
#   echo -n -e '\r\033[K'
#   echo -n -e "当前时间 : $([ $m == 01 -a $d == 01 -a $h == 00 -a $t == 00 -a $s == 00 ] && echo -n -e "\033[1;5;32m$y" || echo -n "$y")\033[0m-$([ $d == 01 -a $h == 00 -a $t == 00 -a $s == 00 ] && echo -n -e "\033[1;5;32m$m" || echo -n "$m")\033[0m-$([ $h == 00 -a $t == 00 -a $s == 00 ] && echo -n -e "\033[1;5;32m$d" || echo -n "$d")\033[0m $([ $t == 00 -a $s == 00 ] && echo -n -e "\033[1;5;32m$h" || echo -n "$h")\033[0m:$([ $s == 00 ] && echo -n -e "\033[1;5;32m$t" || echo -n "$t")\033[0m:$([ $n == 000000000 ] && echo -n -e "\033[1;5;32m$s")"
#   echo -n -e '\033[0m'
#   sleep 0.5
# done





# echo 'env.sh       : $host_name                      : '"$host_name"
# echo 'env.sh       : $user_name                      : '"$user_name"
# echo 'env.sh       : $n_time                         : '"$n_time"
# echo 'env.sh       : $s_time                         : '"$s_time"
# echo 'env.sh       : $o_time                         : '"$o_time"
# echo 'env.sh       : $log_dir                        : '"$log_dir"
# echo 'env.sh       : $info_log                       : '"$info_log"
# echo 'env.sh       : $erro_log                       : '"$erro_log"
# echo 'time_fun.sh  : s_d ymd                         : '$(s_d 'ymd' "$n_time")
# echo 'time_fun.sh  : s_d tt                          : '$(s_d 'tt' "$n_time")
# echo 'time_fun.sh  : s_d FT                          : '$(s_d 'ft' "$n_time")
# echo 'time_fun.sh  : s_d ym                          : '$(s_d 'ym' "$n_time")
# echo 'time_fun.sh  : s_d y                           : '$(s_d 'y' "$n_time")
# echo 'time_fun.sh  : s_d j                           : '$(s_d 'j' "$n_time")
# echo 'time_fun.sh  : s_d m                           : '$(s_d 'm' "$n_time")
# echo 'time_fun.sh  : s_d d                           : '$(s_d 'd' "$n_time")
# echo 'time_fun.sh  : s_d w                           : '$(s_d 'w' "$n_time")
# echo 'time_fun.sh  : s_d u                           : '$(s_d 'u' "$n_time")
# echo 'args_fun.sh  : $(args_extract -endDate)        : '$(args_extract -endDate)
# echo 'args_fun.sh  : $(args_extract -dsendDate 21)   : '$(args_extract -dsendDate "$n_time")
# echo 'args_fun.sh  : args_extract     $startDate     : '"$startDate"
# echo 'args_fun.sh  : args_extract     $endDate       : '"$endDate"
# echo 'args_fun.sh  : params_extract                  : '$(params_extract "$test_arg")
# echo 'args_fun.sh  : array_lenth                     : '$(array_lenth "$(params_extract $test_arg)")
# echo $mysql_td
# echo $mysql_dmp
# echo $mongo
# echo $beeline
# echo $hdfs_path
# echo $ods_source_hdfs
# echo $ods_lowerb_hdfs
# echo $ods_link_hdfs
# echo $ods_bank_hdfs
# echo $ods_source_old_hdfs
# echo $data_dir
# echo $ods_source_data
# echo $ods_lowerb_data
# echo $remote_dir
# echo $ac_file
# echo $bi_file

# echo ${warehouse}

# s_d -b '2019-10-16' -d '-2' 'ft'
# s_d 'ft' $s_time


# echo '距离当前  : '$(during $n_time $s_time)
# echo '当前时间  : '$n_time
# echo '当前时间  : '$(s_d 'tt')
# echo '年月日    : '$(s_d ymd)
# echo '年月      : '$(s_d ym)
# echo '月日      :     '$(s_d md)
# echo '日时      :       '$(s_d dh)
# echo '            '$(s_d 'y' $n_time)'年'
# echo '                '$(s_d 'm' $n_time)'月'
# echo '                  '$(s_d 'd' $n_time)'日'
# echo '                    '$(s_d 'h' $n_time)'时'
# echo '                      '$(s_d 'k' $n_time)'分'
# echo '                        '$(s_d 's' $n_time)'秒'


# for i in {1..3}; do
#   info
#   sleep 1
# done


# test=$data_direct/ods_source

# echo $test

# info "fd gdf" "troi"
# succ "$test" 'succ'
# erro "$test" 'erro'

# s_d 'ft' $s_time

# s_d -b '2019-10-16' -b '2019-10-12' 'ft'
# s_d -b '2019-10-16' 'tt'



# split_fname $test
# echo $file_name
# echo ${sp_fn[0]}
# echo ${sp_fn[1]}
# echo ${sp_fn[2]}
# echo ${sp_fn[0]}.${sp_fn[2]:0:8}

# echo $(slash_analy 'ghdk/ghdi')


# echo $info_log
# echo $erro_log

# [[ $(array_lenth "$(slash_analy "${1:- }")") > 1 ]] && echo 'true' || echo 'false'
# array_lenth "${1:- }"
# split_fname '1fa hgd'
# echo ${sp_fn[@]}
# for i in ${sp_fn[@]}; do
#   echo $i
# done

# split_fdire '2fa hgd'
# echo ${sp_fn[@]}
# for i in ${sp_fn[@]}; do
#   echo $i
# done


# echo $base_time
# echo $date_format
# echo $date_diff
# echo $secon_arg
# echo $format

# echo $conf
# echo $home_dir


# mysqlexport
# mongoexport


# echo $test

# s_r_r $test
# s_l_r $test
# s_r_l $test
# s_l_l $test
# p_r_l $test
# p_l_r $test
# p_l_l $test
# p_r_r $test


# split_name $test
# split_dire $test



# for (( i = 0; i < 10; i++ )); do
#   {
#     echo $i
#     sleep 3
#   } &
# done

# for pid in $(jobs -p); do
#   wait $pid
# done


# s_l_l $(s_l_r $(s_l_r $(s_l_r $test)))
# s_r_r $test

# echo $(split_dire $test)


# [[ -f $data_direct/ods_source/tenant.tsv ]] && echo true || echo false


# printf '\033[33m%236s\033[0m' | sed 's/ /=/g'



# dele=($(c_a $dele_part))  dt=1571846400
# echo $(s_d -f ${dele[0]} -d ${dele[1]} ym $dt) $(s_d -f ${dele[0]} -d ${dele[1]} d $dt)

# for i in {1..10}; do
#   [[ 1 -le i && i -le 3 ]] || continue
#   echo $i
# done


# info

# ss=($(
#   for i in {1..10}; do
#     {
#       sleep 1
#     } &
#   done
#   for pid in $(jobs -p); do
#     echo $pid
#   done
#   ))

# echo ${ss[@]}

# info


# aa=(1 1 2 2 3 5)
# echo 1 1 2 2 3 5 | xargs echo





# curl -F "upload=@/home/winco_weshareholdings/tdid_hash/aa" http://111.230.216.152:8001/getview/web/m/test4

# /home/winco_weshareholdings/tdid_hash/aa

# /data/files/20191104



# ss=('fhdi' 'hgoifd')

# echo ${ss[*]} | sed 's/\s\+/,/g'

# echo $yearmonth_last


# while [[ true ]]; do
#   echo $(( $RANDOM % 100 ))
#   sleep 0.5
# done



# cat /dev/null > $conf/imex.table

# imex_table=$conf/imex.table


# while read line; do
#   line=$(echo $line | grep -Ev '^#|^$')
#   [[ ${line} == '' ]] && continue

#   unset imex type host user passwd database fromdb aimsdb partition tables table

#   kv_get "$line"

#   db=($(c_a $database)) fromdb=${db[0]} aimsdb=${db[1]}

#   for host in $(c_a $hosts); do
#     for table in $(c_a $tables); do
#       [[ $table =~ -$ ]] && partition=year_month:day_of_month
#       table=$(b_a $table)
#       perl_line=$(sed -n "/$aimsdb/{/$table/p}" $imex_table)
#       start_time=$([[ $perl_line == '' ]] && echo $init_time || trim $(echo $perl_line | awk -F '|' '{print $9}'))
#       last_time=$([[ $perl_line == '' ]] && echo $init_time || trim $(echo $perl_line | awk -F '|' '{print $10}'))
#       printf '%-7s | %-8s | %-15s | %-10s | %-16s | %-20s | %-11s | %-24s | %-11s | %-11s | %s\n' \
#       "$imex" "$type" "$host" "${user:--}" "${passwd:--}" "$fromdb" "$aimsdb" "$table" "$start_time" "$last_time" "${partition:--}" \
#       >> $imex_table
#     done
#   done
# done < $conf/imex.conf

# ss=$(sort -u $imex_table)
# echo "$ss" > $imex_table

# file=bi.*.log

# aims_file=/hadoop/data/ods_wefix/$file

# echo $aims_file

# for file in $aims_file; do
#   echo $file
#   # min_time_n=$(p_r_r $(p_r_l $file))
#   # echo $min_time_n
#   # min_time_n=$(s_d -b ${min_time_n:0:8})
#   # echo $min_time_n
#   # min_time=$([[ ${min_time:=$n_time} -le $min_time_n ]] && echo $min_time || echo $min_time_n)
#   # echo $min_time
#   # echo
# done

# echo $min_time

# aims_dir=/hadoop/data/ods_wefix

# stor_data tsv 20191115130800 aa

# table=aa.20191115.tsv

# real_table


# imex=import
# aimsdb=ods_wefix
# table=APP_INFO


# sed -n "/$imex/{/$aimsdb/{/$table/p}}" $imex_table




# echo $(( $RANDOM % 3 ))




# echo $yearmonth


# s_d h $n_time

# abs_path() {
#     # From: https://stackoverflow.com/a/246128
#     #   - To resolve finding the directory after symlinks
#     SOURCE="${BASH_SOURCE[0]}"
#     while [ -h "$SOURCE" ]; do
#         DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
#         SOURCE="$(readlink "$SOURCE")"
#         [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
#     done
#     echo "$( cd -P "$( dirname "$SOURCE" )" && pwd )"
# }


# ~/mysql-5.7.28/bin/mysql -P3306 -hmysql22 -uroot -p'INikGPLun*8v' -Dmicrob


# mysql="mysql -P3306 -hmysql22 -uroot -pINikGPLun*8v -Dmicrob"

# ymd(){ date -d "$1 day" +%Y%m%d; }

# dt=$(ymd '-2')

# uid=$($mysql -N -s -e "select login_userId from ADT_DATA where date(report_date) = $dt;")

# uids=$($mysql -N -s -e "select login_userId from ADT_DATA where date(report_date) = $(ymd '-2');")

# [[ -z $uid ]] && {
#   for uid in $uids; do
#     $mysql -e "insert into ADT_DATA(report_date,login_userId,login_advId,viewer_advId) values($dt,'$uid','','');"
#   done
# } || echo '非空'



# s=(1 2 3 4)
# echo ${s[@]}
# a=(4 5 6 3)
# echo ${a[@]}

# for i in ${a[@]}; do
#   [[ ${s[@]} =~ $i ]] && echo true || echo false
#   echo "${s[@]}" | grep -wi $i
#   echo $?
# done

# dir_home=/home/hdfs/starsource

# dirs=.,bin,lib,conf

# for dir in ${dirs//,/ }; do
#   cd $dir_home/$dir
#   # 将数据输出到标准错误输出中
#   pwd >&2
# done


# printf '%180s\n' | sed 's/ /-/g'

# prt(){ printf "\n\n%$2s\n" | sed "s/ /$1/g"; }

# prt '-' 120
# prt '成功' '30'






# OPTIND=1
# while getopts :e:m:s:t: opt; do
#   case $opt in
#     (e) etime="$OPTARG" ;;
#     (s) stime="$OPTARG" ;;
#     (m) p_num="$OPTARG" ;;
#     (t) info_type="$OPTARG" ;;
#     (:) echo "请添加参数: -$OPTARG" ;;
#     (?) echo "选项未设置: -$OPTARG" ;;
#     (*) echo "未知情况" ;;
#   esac
# done
# [[ $stime -lt $etime ]] && ftime=$stime stime=$etime etime=$ftime
# for (( ftime = ${stime:=$(date +%Y%m%d)}; ftime >= ${etime:=20190101}; ftime=$(date -d "-1 day $ftime" +%Y%m%d) )); do
#   year_month=${ftime:0:6}   day_of_month=${ftime:6:2}
#   sql+="
#   ALTER TABLE ods_wefix.atd_black_json DROP IF EXISTS PARTITION (year_month='${year_month}',day_of_month='${day_of_month}');
#   ALTER TABLE ods_wefix.atd_black_json ADD IF NOT EXISTS PARTITION (year_month='${year_month}',day_of_month='${day_of_month}');
#   "
#   d_diff=$(( ($(date -d $stime +%s) - $(date -d $ftime +%s)) / 86400 ))
#   [[ ($d_diff != 0 && $(( $d_diff % ${p_num:-150} )) == 0) || $ftime == $etime ]] || continue
#   beeline -u jdbc:hive2://spark:10000 -n hdfs -e "${sql}"
#   unset sql
# done



# echo -ne '
# execut  | beeline  | spark                     | hdfs       | 10000            | -                              | dm_cf       | addition_overview.hql          | 1546272000  | 1546272000  | -
# execut  | beeline  | spark                     | hdfs       | 10000            | -                              | dm_cf       | adt_admin.hql                  | 1546272000  | 1546272000  | -
# execut  | beeline  | spark                     | hdfs       | 10000            | -                              | dm_cf       | adt_data.hql                   | 1546272000  | 1546272000  | -
# execut  | beeline  | spark                     | hdfs       | 10000            | -                              | dm_cf       | advertising_space.hql          | 1546272000  | 1546272000  | -
# execut  | beeline  | spark                     | hdfs       | 10000            | -                              | dm_cf       | data_preference.hql            | 1546272000  | 1546272000  | -
# execut  | beeline  | spark                     | hdfs       | 10000            | -                              | dm_cf       | retention_overview.hql         | 1546272000  | 1546272000  | -
# export  | mysql    | mysql22                   | root       | INikGPLun*8v     | dm_cf                          | microb      | addition_overview              | 1546272000  | 1546272000  | -
# export  | mysql    | mysql22                   | root       | INikGPLun*8v     | dm_cf                          | microb      | adt_admin                      | 1546272000  | 1546272000  | -
# export  | mysql    | mysql22                   | root       | INikGPLun*8v     | dm_cf                          | microb      | adt_data                       | 1546272000  | 1546272000  | -
# export  | mysql    | mysql22                   | root       | INikGPLun*8v     | dm_cf                          | microb      | advertising_space              | 1546272000  | 1546272000  | -
# export  | mysql    | mysql22                   | root       | INikGPLun*8v     | dm_cf                          | microb      | data_preference                | 1546272000  | 1546272000  | -
# export  | mysql    | mysql22                   | root       | INikGPLun*8v     | dm_cf                          | microb      | retention_overview             | 1546272000  | 1546272000  | -
# import  | local    | app41                     | -          | -                | /app_home/logs/ads             | ods_wefix   | access.x.log                   | 1546272000  | 1546272000  | 20190101
# import  | local    | app41                     | -          | -                | /app_home/logs/ads             | ods_wefix   | bi.x.log                       | 1546272000  | 1546272000  | 20190101
# import  | local    | app41                     | -          | -                | /app_home/logs/strategy        | ods_wefix   | atd_black.x.log                | 1546272000  | 1546272000  | 20190101
# import  | local    | app41                     | -          | -                | /app_home/logs/strategy        | ods_wefix   | atd_device.x.log               | 1546272000  | 1546272000  | 20190101
# import  | local    | app41                     | -          | -                | /app_home/logs/strategy        | ods_wefix   | atd_ip.x.log                   | 1546272000  | 1546272000  | 20190101
# import  | mongodb  | mongo26                   | mongouser  | 6xVMjclL5DSGJPZ  | starsource                     | ods_source  | CLIENT_INFO                    | 1546272000  | 1546272000  | -
# import  | mongodb  | mongo26                   | mongouser  | 6xVMjclL5DSGJPZ  | starsource                     | ods_source  | EVENT_LOGGER                   | 1546272000  | 1546272000  | 20190101
# import  | mongodb  | mongo26                   | mongouser  | 6xVMjclL5DSGJPZ  | starsource                     | ods_source  | FLOW_RECORD                    | 1546272000  | 1546272000  | 20190101
# import  | mongodb  | mongo26                   | mongouser  | 6xVMjclL5DSGJPZ  | starsource                     | ods_source  | PRODUCT_INFO                   | 1546272000  | 1546272000  | -
# import  | mongodb  | mongo26                   | mongouser  | 6xVMjclL5DSGJPZ  | starsource                     | ods_source  | RECOMMEND_FLOW                 | 1546272000  | 1546272000  | 20190101
# import  | mongodb  | mongo26                   | mongouser  | 6xVMjclL5DSGJPZ  | starsource                     | ods_source  | SOURCE_INFO                    | 1546272000  | 1546272000  | -
# import  | mysql    | mysql07                   | root       | RRDdjhPULOdZ703  | app_builder_um                 | ods_source  | TENANT                         | 1546272000  | 1546272000  | -
# import  | mysql    | mysql22                   | root       | INikGPLun*8v     | microb                         | ods_wefix   | ACQUISITION_PLAN               | 1546272000  | 1546272000  | -
# import  | mysql    | mysql22                   | root       | INikGPLun*8v     | microb                         | ods_wefix   | ADVERTISEMENT_INFO             | 1546272000  | 1546272000  | -
# import  | mysql    | mysql22                   | root       | INikGPLun*8v     | microb                         | ods_wefix   | APP_INFO                       | 1546272000  | 1546272000  | -
# import  | mysql    | mysql22                   | root       | INikGPLun*8v     | microb                         | ods_wefix   | EXCHANGE_INFO                  | 1546272000  | 1546272000  | -
# import  | mysql    | mysql22                   | root       | INikGPLun*8v     | microb                         | ods_wefix   | EXCHANGE_INFO_CHILD            | 1546272000  | 1546272000  | -
# ' | awk -F '[| ]*' '{
#   print_format="%-7s | %-8s | %-25s | %-10s | %-16s | %-30s | %-11s | %-30s | %-11s | %-11s | %s\n"
#   if($1 == "import" && $2 == "mysql" && $7 == "ods_source" && $8 == "TENANT"){
#     format="%-7s | %-8s | %-25s | %-10s | %-16s | %-30s | %-11s | %-30s | %-11s | %-11s | %-8s | ==============\n"
#     printf format,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11
#     $8 = "aa"
#     printf format,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11
#   }
#   printf print_format,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11
#   # > "./conf/imex.table"
# }'




# during(){
#   s_time=$(date -d "$1" +%s)
#   e_time=$(date -d "$2" +%s)
#   [[ $s_time > $e_time ]] && u=$(( $s_time - $e_time )) || u=$(( $e_time - $s_time ))
#   s=$(( $u % 60 )) u=$(( $u / 60 ))
#   m=$(( $u % 60 )) u=$(( $u / 60 ))
#   h=$(( $u % 24 ))
#   d=$(( $u / 24 ))
#   printf '%d天%02d时%02d分%02d秒' $d $h $m $s
# }

# echo -e "${start:=$(date +'%F %T')} 执行数据任务  开始\n"

# endDate=${1:-$(date -d '-1 day' +%F)}

# while [[ $(date -d "$endDate" +%j) -lt ${today:=$(date +%j)} ]]; do
#   flag=false
#   while ! $flag; do
#     beeline -n hive -u jdbc:hive2://node47:10000 --hivevar compute_date=${endDate} -f ./hive.hql
#     flag=$([[ $? == 0 ]] && echo true || echo false)
#   done
#   endDate=$(date -d "-$(( $today - $(date -d "$endDate" +%j) - 1 )) day" +%F)
# done

# echo -e "${end:=$(date +'%F %T')} 执行数据任务  结束    用时：$(during $end $start)) )\n\n"


# for hql in $base_dir/hive_hql/*; do
#   sh $base_dir/hive_manage.sh $hql &>> $log_file &
# done




# file=(${1:-
#   "$base_dir/hive_hql/ods_new_s.*.hql"
#   "$base_dir/hive_hql/dw_new.*.hql"
# })
# echo ${file[@]} '--' ${file[1]}





# 采用参数的形式，既传到屏幕，又传到文件
# aa=${1:-./bb.log}
# {
#   echo aa 1>&2
#   echo bb
# } 2>&1 1> ./aa.log | tee $aa
