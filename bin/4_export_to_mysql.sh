#!/bin/bash -e

. $(dirname "${BASH_SOURCE[0]}")/../lib/env.sh

info 'Execute Export_File' '导出数据到MySQL执行开始'



while read line; do
  imex_analyze "${line}"

  [[ $imex != export ]] && continue

  hive_tbl
  table=$(real_table)
  hive_dbtable=${fromdb}.${table}
  mysql_table=$(high_case ${table})
  mysql_file=${mysql_dir}/${table}.csv

  startDate=$(ymd $last_time)
  endDate=$(ymd $start_time)


  hive_field=($($beeline --showHeader=false --outputformat=tsv2 --hivevar db_table=${hive_dbtable} -e 'desc ${db_table};' 2>> /dev/null | awk '{print $1}'))

  mysql_field=($(mysql -P3306 -h${host} -u${user} -p${passwd} -D${aimsdb} -s -N -e "desc ${mysql_table};" | awk '{print $1}'))


  fields=''
  for field in ${hive_field[@]}; do
    [[ ${mysql_field[@]} =~ $field ]] && fields=$(trim_m $(echo "${fields} ${field}" | sed 's/\s\+/,/g')) || continue
  done
  [[ $? == 0 ]] && succ "Fields_Filter $hive_dbtable" '过滤字段成功' || erro "Fields_Filter $hive_dbtable" '过滤字段失败'


  while [[ $startDate -le $endDate ]]; do
    ym=${startDate:0:6} dm=${startDate:6:2}
    startDate=$(diff_day $startDate)

    $beeline --showHeader=false --outputformat=csv2 \
    --hivevar tbl_fields=${fields} --hivevar db_table=${hive_dbtable} \
    --hivevar year_month=$ym --hivevar day_of_month=$dm \
    -e 'select ${tbl_fields} from ${db_table} where year_month = ${year_month} and day_of_month = ${day_of_month}' > $mysql_file
    [[ $? == 0 ]] && \
    succ "Extract_Hive_${ym}${dm} $hive_dbtable" '抽取Hive数据到本地成功' || \
    erro "Extract_Hive_${ym}${dm} $hive_dbtable" '抽取Hive数据到本地失败'

    [[ $(stat -c %s $mysql_file) == 0 ]] && {
      warn "LOCAL_File $mysql_file" '文件为空，跳过加载到MySQL'
      continue
    } || info "LOCAL_File $mysql_file" '文件为空，跳过加载到MySQL'

    mysql -P3306 -h${host} -u${user} -p${passwd} -D${aimsdb} -e "LOAD DATA LOCAL INFILE '$mysql_file' REPLACE INTO TABLE ${mysql_table} FIELDS TERMINATED BY ',' (${fields})"
    [[ $? == 0 ]] && \
    succ "MySQL_Load_Data From_$mysql_file" 'MySQL加载数据到表中，执行成功' || \
    erro "MySQL_Load_Data From_$mysql_file" 'MySQL加载数据到表中，执行失败'
  done
done < $imex_table





info 'Execute Export_File' '导出数据到MySQL执行结束'

