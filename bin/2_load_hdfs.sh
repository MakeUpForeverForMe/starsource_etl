#!/bin/bash -e

. $(dirname "${BASH_SOURCE[0]}")/../lib/env.sh


sasp_load='Load_File Into_HDFS'

info "$sasp_load" '执行开始'



hdfs_put(){
  info "Load $(s_r_r $1)" '开始执行'
  # printf '%4s %3s %4s %2s %-80s %s\n' \
  hdfs dfs -put -f $1 $2
  [[ $? == 0 ]] && succ "HDFS_Put $(s_r_r $1)" '上传成功' || erro "HDFS_Put $(s_r_r $1)" '上传失败'
}

if [[ -f $data_direct/ods_source/tenant.tsv ]]; then
  mv $data_direct/ods_source/tenant.tsv $data_direct/ods_source/org_info.tsv
  [[ $? == 0 ]] && \
  succ 'rename-tenant.tsv to-org_info.tsv' '执行成功' || \
  erro 'rename-tenant.tsv to-org_info.tsv' '执行失败'
fi


# while read line; do
#   imex_analyze "${line}"

#   [[ $imex != import ]] && continue
#   [[ $table =~ bi ]] && continue
#   [[ $table == TENANT ]] && table=org_info

#   hive_tbl # 其中含有 file_type
#   table=$real_table

#   aims_dir=$data_direct/$aimsdb
#   load_hdfs_dir=$hdfs_path/${aimsdb}.db/${table}_${file_type}


#   [[ $partition =~ - ]] && {
#     # 普通表
#     {
#       load_gene_file=$(stor_data $file_type)
#       hdfs_put $load_gene_file $load_hdfs_dir
#     } &
#   } || {
#     # 分区表
#     min_load_time=$(ymd $last_time)
#     max_load_time=$(ymd $start_time)
#     while [[ $min_load_time -le $max_load_time ]]; do
#       {
#         load_part_file=$(stor_data $file_type $min_load_time)
#         # 判断文件是否存在
#         [[ -f $load_part_file ]] && \
#         hdfs_put $load_part_file ${load_hdfs_dir}/year_month=${min_load_time:0:6}/day_of_month=${min_load_time:6:2}
#       } &
#       # 时间递加
#       min_load_time=$(diff_day $min_load_time)
#     done
#   }
#   p_opera
# done < $imex_table







while read line; do
  imex_analyze "${line}"

  [[ $imex != import ]] && continue
  [[ $table =~ bi ]] && continue
  [[ $table == TENANT ]] && table=org_info

  hive_tbl # 其中含有 file_type
  table=$real_table

  aims_dir=$data_direct/$aimsdb
  load_hdfs_dir=$hdfs_path/${aimsdb}.db/${table}_${file_type}

  fields=($(echo "${fields[*]} $file_type:$aims_dir:$table:$last_time:$start_time:$partition:$load_hdfs_dir" | sed 's/ /\n/g' | sort -u) )

done < $imex_table

for filed in ${fields[@]}; do
  filed_names=($(c_a $filed))

  # echo ${filed_names[@]}

  file_type=${filed_names[0]}
  aims_dir=${filed_names[1]}
  table=${filed_names[2]}
  last_time=${filed_names[3]}
  start_time=${filed_names[4]}
  partition=${filed_names[5]}
  load_hdfs_dir=${filed_names[6]}

  # [[ $partition == - ]] && \
  # echo "file_type:$file_type  aims_dir:$aims_dir  table:$table  last_time:$last_time  start_time:$start_time  partition:$partition  load_hdfs_dir:$load_hdfs_dir"
   # || echo 'ghjkh-------------'

  # echo $file_type
  # echo $aims_dir
  # echo $table
  # echo $last_time
  # echo $start_time
  # echo $partition


  [[ $partition == - ]] && {
    # 普通表
    {
      load_gene_file=$(stor_data $file_type)
      hdfs_put $load_gene_file $load_hdfs_dir
    } &
  } || {
    # 分区表
    min_load_time=$(ymd $last_time)
    max_load_time=$(ymd $start_time)
    while [[ $min_load_time -le $max_load_time ]]; do
      {
        load_part_file=$(stor_data $file_type $min_load_time)
        # 判断文件是否存在
        [[ -f $load_part_file ]] && \
        hdfs_put $load_part_file ${load_hdfs_dir}/year_month=${min_load_time:0:6}/day_of_month=${min_load_time:6:2} || \
        warn "$load_part_file" '文件不存在，跳过本次上传'
      } &
      # 时间递加
      min_load_time=$(diff_day $min_load_time)
    done
  }
  p_opera
  # [[ $table == access ]] && break
done




# # 等待并行执行结束
wait_jobs


info "$sasp_load" '执行结束'

