#!/bin/bash -e

. $(dirname "${BASH_SOURCE[0]}")/../lib/env.sh

sasp_add_delete=$(printf '%-16s %-16s %-16s %s' 'ALTER' 'TABLE' 'ADD' 'PARTITION')

info "$sasp_add_delete" '执行开始'

# 删除分区距今天时长
# 解析为 ${dele[0]}=year ${dele[1]}=2
dele=($(c_a $dele_part))


while read line; do
  imex_analyze "${line}"

  [[ $imex == import && $partition != - ]] || continue
  [[ $table =~ bi ]] && continue

  {
    hive_tbl

    partition=($(c_a $partition)) add_part=''
    f_time=$(s_d ymd $start_time) add_end_time=$(s_d ymd $n_time)


    while [[ ${f_time} -le $add_end_time ]]; do
      de_ymd=$(s_d -f ${dele[0]} -d "-${dele[1]}" -b ${f_time} ymd)
      ym_add=${f_time:0:6}  dm_add=${f_time:6:2}  ym_del=${de_ymd:0:6}  dm_del=${de_ymd:6:2}

      add_part+="ALTER TABLE ${dttb} ADD IF NOT EXISTS PARTITION (${partition[0]}='${ym_add}',${partition[1]}='${dm_add}'); ALTER TABLE ${dttb} DROP IF EXISTS PARTITION (${partition[0]}='${ym_del}',${partition[1]}='${dm_del}');"

      f_time=$(diff_day $f_time)
    done
    $beeline -e "$add_part"
    detail_info=$(printf '%30s %15s' ${dttb} AddPartition_And_DeletePartition)
    [[ $? == 0 ]] && succ "$detail_info" '执行成功' || erro "$detail_info" '执行失败'
  } &
  p_opera
  # break
done < $imex_table

wait_jobs

info "$sasp_add_delete" '执行结束'



