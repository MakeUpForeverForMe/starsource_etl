#!/bin/bash -e

. $(dirname "${BASH_SOURCE[0]}")/../lib/env.sh

info 'Init Conf' '初始化执行开始'


[[ ! -f $imex_table ]] && echo > $imex_table

print_format='%-7s | %-8s | %-25s | %-10s | %-16s | %-20s | %-11s | %-30s | %-11s | %-11s | %s\n'



# cat $imex_table

old_IFS=$IFS
new_IFS=$'\n'
IFS=$new_IFS

# 对于配置文件的读取与解析
for line in $(grep -vE '^#|^$' $conf/imex.conf); do
  IFS=$old_IFS

  unset user passwd

  kv_get "$line"

  db=($(c_a $database)) fromdb=${db[0]} aimsdb=${db[1]}

  for table in $(c_a $tables); do
    table_l=$table  table=$(b_a $table)

    perl_line=$(sed -n "/$imex/{/$aimsdb/{/$table/p}}" $imex_table)
    perl_line_arr=($(v_a "$perl_line"))

    start_time=$([[ $perl_line == '' ]] && echo $init_time || echo ${perl_line_arr[8]})
    last_time=$([[ $perl_line == '' ]] && echo $init_time || echo ${perl_line_arr[9]})
    partition=$([[ $table_l =~ -$ ]] && { [[ $perl_line == '' ]] && ymd $init_time || echo ${perl_line_arr[10]};} || echo '-')
    # imex        导出导入类型
    # type        数据库类型
    # hosts       存储来源主机
    # user        来源主机用户
    # passwd      来源主机密码
    # fromdb      来源数据库
    # aimsdb      目标数据库
    # table       来源数据库和目标数据库中的相同表
    # start_time  任务开始时间
    # last_time   上次任务时间
    # partition   记录分区时间字段（默认为：20190101）
    printf "$print_format" "$imex" "$type" "$hosts" "${user:--}" "${passwd:--}" "$fromdb" "$aimsdb" "$table" "$start_time" "$last_time" "$partition" >> $imex_table
  done
  IFS=$new_IFS
done
IFS=$old_IFS


# 获取数仓中的所有库表
for ware_db in $($beeline --showHeader=false --outputformat=tsv2 -e 'show databases;' 2>> /dev/null | grep -Ev 'default|information_schema|sys'); do
  for ware_table in $($beeline --showHeader=false --outputformat=tsv2 -e "show tables from $ware_db;" 2>> /dev/null); do
    from_ware_tbl=($(echo ${from_ware_tbl[@]}) ${ware_db}.${ware_table})
  done
done


# 对于执行文件的读取与解析
for level in ${ware_level[@]}; do
  for execut_hql in $warehouse/$level/*/*.hql; do
    imex=execut
    unset fromdb
    aimsdb=$(s_r_r $(s_r_l $execut_hql))
    table_hql=$(s_r_r $execut_hql)
    table=$(p_r_l $table_hql)

    for has_table in ${from_ware_tbl[@]}; do
      [[ $has_table == ${aimsdb}.${table} ]] && continue
      [[ $(sed -n "/$has_table/p" $execut_hql) != '' ]] && fromdb=($(echo ${fromdb[@]}) $has_table)
    done
    fromdb=$(echo ${fromdb[*]} | sed 's/ /:/g')

    perl_line=$(sed -n "/$imex/{/$aimsdb/{/$table_hql/p}}" $imex_table)
    start_time=$([[ $perl_line == '' ]] && echo $init_time || trim $(echo $perl_line | awk -F '|' '{print $9}'))
    last_time=$([[ $perl_line == '' ]] && echo $init_time || trim $(echo $perl_line | awk -F '|' '{print $10}'))

    printf "$print_format" "$imex" "$beeline_home" "$beeline_host" "$beeline_user" "$beeline_port" "$fromdb" "$aimsdb" "$table_hql" "$start_time" "$last_time" "$partition" >> $imex_table
  done
done

# sed -i '1,3d' conf/imex.table

ss=$(sort -u $imex_table | sed '/^\s*$/d')
echo "$ss" > $imex_table

# sed -i "1i $(printf '%190s\n' | sed 's/ /-/g')" conf/imex.table
# sed -i "1i $(printf "$print_format" 'imex' 'type' 'hosts' 'user' 'passwd' 'fromdb' 'aimsdb' 'table' 'start_time' 'last_time' 'partition')" conf/imex.table
# sed -i "1i $(printf '%190s\n' | sed 's/ /-/g')" conf/imex.table


info 'Init Conf' '初始化执行结束'

cat $imex_table


