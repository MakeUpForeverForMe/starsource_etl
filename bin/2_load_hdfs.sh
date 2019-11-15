#!/bin/bash -e

. $(dirname "${BASH_SOURCE[0]}")/../lib/env.sh


sasp_load=$(printf '%-17s %-18s %-18s %s' 'Load' 'File' 'Into' 'HDFS')

info "$sasp_load" '执行开始'


ptf(){ printf '%-7s %-63s %s' 'HDFS' "$1" 'Put'; }
succ_erro(){ [[ $? == 0 ]] && succ "$(ptf "$1")" '上传成功' || erro "$(ptf "$1")" '上传失败'; }


if [[ -f $data_direct/ods_source/tenant.tsv ]]; then
  mv $data_direct/ods_source/tenant.tsv $data_direct/ods_source/org_info.tsv
  [[ $? == 0 ]] && \
  succ 'rename-tenant.tsv to-org_info.tsv' '执行成功' || \
  erro 'rename-tenant.tsv to-org_info.tsv' '执行失败'
fi


while read line; do
  imex_analyze "${line}"

  [[ $imex != import ]] && continue
  [[ $table =~ bi ]] && continue
  [[ $table == TENANT ]] && table=org_info

  hive_tbl
  table=$(real_table)

  aims_dir=$data_direct/$aimsdb
  load_hdfs_dir=$hdfs_path/${aimsdb}.db/${table}_${file_type}

  [[ $partition =~ - ]] && {
    # 普通表
    {
      load_gene_file=$(stor_data $file_type)
      # printf '%4s %3s %4s %2s %-80s %s\n' \
      hdfs dfs -put -f $load_gene_file $load_hdfs_dir
      succ_erro $(s_r_r $load_gene_file)
    } &
  } || {
    # 分区表
    min_load_time=$(ymd $last_time)
    max_load_time=$(ymd $start_time)
    while [[ $min_load_time -le $max_load_time ]]; do
      {
        load_part_file=$(stor_data $file_type $min_load_time)
        # 判断文件是否存在
        [[ -f $load_part_file ]] && {
          # printf '%4s %3s %4s %2s %-80s %s\n' \
          hdfs dfs -put -f $load_part_file ${load_hdfs_dir}/year_month=${min_load_time:0:6}/day_of_month=${min_load_time:6:2}
          succ_erro $(s_r_r $load_part_file)
        }
      } &
      # 时间递加
      min_load_time=$(diff_day $min_load_time)
    done
  }
  p_opera
done < $imex_table


# # 等待并行执行结束
wait_jobs


info "$sasp_load" '执行结束'

