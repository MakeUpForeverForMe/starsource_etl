#!/bin/bash -e

. $(dirname "${BASH_SOURCE[0]}")/../lib/env.sh

info 'Init Conf' '初始化执行开始'


[[ ! -f $imex_table ]] && echo > $imex_table


sed -i '1,3d' conf/imex.table

# cat $imex_table


while read line; do
  line=$(echo $line | grep -Ev '^#|^$')
  [[ ${line} == '' ]] && continue

  unset imex type host user passwd database fromdb aimsdb partition tables table

  kv_get "$line"

  db=($(c_a $database)) fromdb=${db[0]} aimsdb=${db[1]}

  for host in $(c_a $hosts); do
    for table in $(c_a $tables); do
      [[ $table =~ -$ ]] && partition=year_month:day_of_month || unset partition
      table=$(b_a $table)
      perl_line=$(sed -n "/$imex/{/$aimsdb/{/$table/p}}" $imex_table)
      start_time=$([[ $perl_line == '' ]] && echo $init_time || trim $(echo $perl_line | awk -F '|' '{print $9}'))
      last_time=$([[ $perl_line == '' ]] && echo $init_time || trim $(echo $perl_line | awk -F '|' '{print $10}'))
      # imex        导出导入类型
      # type        数据库类型
      # host
      # user
      # passwd
      # fromdb      来源数据库
      # aimsdb      目标数据库
      # table       来源数据库和目标数据库中的相同表
      # start_time  任务开始时间
      # last_time   上次任务时间
      # partition   分区字段（默认为year_month:day_of_month）
      printf '%-7s | %-8s | %-15s | %-10s | %-16s | %-20s | %-11s | %-30s | %-11s | %-11s | %s\n' \
      "$imex" "$type" "$host" "${user:--}" "${passwd:--}" "$fromdb" "$aimsdb" "$table" "$start_time" "$last_time" "${partition:--}" >> $imex_table
    done
  done
done < $conf/imex.conf


for level in ${ware_level[@]}; do
  for execut_hql in $warehouse/$level/*/*.hql; do
    imex=execut
    aimsdb=$(s_r_r $(s_r_l $execut_hql))
    fromdb=$level
    table=$(s_r_r $execut_hql)

    perl_line=$(sed -n "/$imex/{/$aimsdb/{/$table/p}}" $imex_table)
    start_time=$([[ $perl_line == '' ]] && echo $init_time || trim $(echo $perl_line | awk -F '|' '{print $9}'))
    last_time=$([[ $perl_line == '' ]] && echo $init_time || trim $(echo $perl_line | awk -F '|' '{print $10}'))

    printf '%-7s | %-8s | %-15s | %-10s | %-16s | %-20s | %-11s | %-30s | %-11s | %-11s | %s\n' \
    "$imex" "$beeline_home" "$beeline_host" "$beeline_user" "$beeline_port" "$fromdb" "$aimsdb" "$table" "$start_time" "$last_time" "${partition:--}" >> $imex_table
  done
done

ss=$(sort -u $imex_table | sed '/^\s*$/d')
echo "$ss" > $imex_table

sed -i "1i $(printf '%190s\n' | sed 's/ /-/g')" conf/imex.table
sed -i "1i $(printf '%-7s | %-8s | %-15s | %-10s | %-16s | %-20s | %-11s | %-30s | %-11s | %-11s | %s\n' \
'imex' 'type' 'host' 'user' 'passwd' 'fromdb' 'aimsdb' 'table' 'start_time' 'last_time' 'partition')" conf/imex.table
sed -i "1i $(printf '%190s\n' | sed 's/ /-/g')" conf/imex.table


info 'Init Conf' '初始化执行结束'

cat $imex_table


