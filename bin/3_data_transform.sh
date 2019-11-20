#!/bin/bash -e

. $(dirname "${BASH_SOURCE[0]}")/../lib/env.sh

info 'Execute Hql_File' '执行开始'



for level in ${ware_level[@]}; do
  while read line; do
    imex_analyze "${line}"

    from_db=($(u_a $aimsdb))

    [[ $imex == execut && ${from_db[0]} == $level ]] || continue

    execut_hql=$warehouse/${from_db[0]}/$aimsdb/$table

    [[ ! -f $execut_hql ]] && continue

    startDate=$(ymd $last_time)
    endDate=$(ymd $start_time)


    unset tbl_time
    for db_tbl in $(c_a $fromdb); do
      db_tbl=$(u_r_l $(p_l_r $db_tbl))
      tbl_time=($(echo ${tbl_time[@]}) $(sed -n "/import/{/$(lowe_case $db_tbl)/p; /$(high_case $db_tbl)/p}" $imex_table | awk -F '|' '{print $10}'))
    done
    tbl_time=$(echo ${tbl_time[*]} | sed 's/\s\+/\n/g' | sort | head -n 1)
    edit_time $tbl_time



    while [[ $startDate -le $endDate ]]; do
      ym=${startDate:0:6} dm=${startDate:6:2}
      startDate=$(diff_day $startDate)
      {
        info "$aimsdb--${ym}${dm} $table" '开始执行'
        # 小测试，随机等待0-3秒。演示并发
        # sleep $(echo $(( $RANDOM % 3 )))
        # printf '%7s %2s %24s %2s %4s %10s %17s %10s %15s %2s %s\n' \
        $beeline --hivevar year_month=$ym --hivevar day_of_month=$dm -f $execut_hql
        [[ $? == 0 ]] && \
        succ "$aimsdb--${ym}${dm} $table" '执行成功' || \
        erro "$aimsdb--${ym}${dm} $table" '执行失败'
      } &
      p_opera
    done
  done < $imex_table
  # 等待一层结束
  wait_jobs
done





info 'Execute Hql_File' '执行完成'

