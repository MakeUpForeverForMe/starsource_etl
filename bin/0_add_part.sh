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
    # 获取到
    # real_table：client_info
    # file_type：tsv json
    # dttb：ods_source.cleint_info_json
    hive_tbl

    add_part=''
    f_time=$partition add_end_time=$(s_d ymd $n_time)

    while [[ ${f_time} -le $add_end_time ]]; do
      de_ymd=$(s_d -f ${dele[0]} -d "-${dele[1]}" -b ${f_time} ymd)
      ym_add=${f_time:0:6}  dm_add=${f_time:6:2}
      ym_del=${de_ymd:0:6}  dm_del=${de_ymd:6:2}
      # 必须放在其他日期计算的后面
      f_time=$(diff_day $f_time)

      add_part+="
      ALTER TABLE ${dttb} DROP IF EXISTS PARTITION (year_month='${ym_add}',day_of_month='${dm_add}');
      ALTER TABLE ${dttb} ADD IF NOT EXISTS PARTITION (year_month='${ym_add}',day_of_month='${dm_add}');
      ALTER TABLE ${dttb} DROP IF EXISTS PARTITION (year_month='${ym_del}',day_of_month='${dm_del}');
      "

    done
    detail_info_beeline=$(printf '%30s %15s' ${dttb} AddPartition_And_DeletePartition)
    $beeline -e "$add_part"
    [[ $? == 0 ]] && succ "$detail_info_beeline" '执行成功' || erro "$detail_info_beeline" '执行失败'

    detail_info_sed="$aimsdb.$table $partition--$add_end_time"
    sed -i "/$imex/{/$aimsdb/{/$table/s/$partition/$add_end_time/}}" $imex_table
    [[ $? == 0 ]] && succ "$detail_info_sed" '修改分区时间成功' || erro "$detail_info_sed" '修改分区时间失败'
  } &
  p_opera
  # break
done < $imex_table

wait_jobs

info "$sasp_add_delete" '执行结束'



