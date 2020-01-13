#!/bin/bash -e


. $(dirname "${BASH_SOURCE[0]}")/../lib/env.sh


info '从各数据源获取数据' '执行开始'



# 一个小测试
# while read line; do
#   imex_analyze "${line}"
#   [[ $imex != import ]] && continue
#   # [[ $table =~ t_ad_query_water|t_ad_action_water ]] && continue

#   if [[ $type == mysql ]]; then
#     stor_data tsv
#     edit_time
#   elif [[ $type == mongodb ]]; then
#     stor_data json
#     edit_time
#   elif [[ $type == local ]]; then
#     stor_data json 201911140000 t_ad_query_water
#     edit_time
#     edit_time $min_time ods_wefix t_ad_action_water.x.log
#     edit_time $min_time ods_wefix t_ad_query_water.x.log
#   fi
# done < $imex_table

# cat $imex_table

while read line; do
  imex_analyze "${line}"

  [[ $imex != import ]] && continue
  [[ $table =~ t_ad_query_water|t_ad_action_water ]] && continue

  # 数据存储目录
  aims_dir=$data_direct/$aimsdb
  # 抽取数据的执行SQL主目录
  extract_dir=$warehouse/extract/$aimsdb
  # 创建不存在的文件夹
  exist_dir $aims_dir
  # 获取表名
  table_tmp=($(p_a $table)) table=${table_tmp[0]}
  # 设置日志输出的内容
  thdt=$(echo $type $host $fromdb $(lowe_case $table))
  # 重新赋值开始时间
  f_time=$start_time


  # 判断配置的类型，是从MySQL、Oracle、MongoDB、Local等来源抽取数据到本地
  if [[ $type == local ]]; then # Local类型来源
    {
      # file：access.*.log
      file=${table}.*.${table_tmp[$(( ${#table_tmp[@]} - 1 ))]}
      # from_file：/data/logs/ads/access.*.log
      from_file=$fromdb/$file
      # aimsfile：/hadoop/data/ods_wefix/access.*.log
      aimsfile=$aims_dir/$file

      for host in $(c_a $hosts); do
        info "scp $host:$from_file $aims_dir" '开始执行获取远程文件'
        scp $host:$from_file $aims_dir
        [[ $? == 0 ]] && succ "$host $from_file" '远程拷贝成功，开始删除远程文件' || { warn "$host $from_file" '远程文件未生成或无该文件，不能拷贝至本地，跳过执行'; continue; }


        [[ $(ls $aimsfile) == '' ]] && { warn "Local_File $aimsfile" '文件不存在，跳过执行'; continue; }

        if [[ $aimsfile =~ bi ]]; then
          for bitype in $(grep -Po 'biType[":]+\K[^"]+' $aimsfile | sort -u); do
            file_type=($(c_a $bitype))
            [[ ${#file_type[@]} == 1 ]] && aims_file=$aimsfile bi_type=$bitype || aims_file=${file_type[0]} bi_type=${file_type[1]}
            grep "$bi_type" $aims_file >> $(stor_data json $(p_r_r $(p_r_l $aims_file)) $bi_type)
            [[ $? == 0 ]] && succ "$aims_file $bi_type" '重新分配内容成功' || { erro "$aims_file $bi_type" '重新分配内容失败'; exit 1; }
          done
        else
          for other_file in $aimsfile; do
            info_detail="$other_file $(p_l_l $(s_r_r $other_file))"
            detail=$(grep -vE '^\s*$' $other_file)
            [[ -n $detail ]] || { warn "$info_detail" '此文件为空，直接跳过重新分配内容'; continue; }
            echo "$detail" >> $(stor_data json $(p_r_r $(p_r_l $other_file)))
            [[ $? == 0 ]] && succ "$info_detail" '重新分配内容成功' || { erro "$info_detail" '重新分配内容失败'; exit 1; }
          done
        fi

        # ssh后直接退出，接了 -n 后问题解决
        ssh -n $host "rm -f $from_file"
        [[ $? == 0 ]] && succ "$host $from_file" '远程文件删除成功' || erro "$host $from_file" '远程文件删除失败'

        # 获取时间上的最小值文件的时间
        min_file=$(p_r_r $(p_r_l $(ls -tr $aimsfile | head -n 1)))
        min_time=$(s_d -b ${min_file:0:8})

        edit_time $min_time
        [[ $aimsfile =~ bi ]] && {
          edit_time $min_time t_ad_action_water
          edit_time $min_time t_ad_query_water
        }

        rm -rf $aimsfile && info "rm -rf $aimsfile" '删除本地已经处理过的数据'
      done
    } &
  elif [[ $type == mysql ]]; then # MySQL类型来源
    {
      # 针对个别需要的文件单独执行，否则以与目录相同的文件执行
      extract=$extract_dir/$([[ $(ls $extract_dir | grep .sql$) =~ $(lowe_case $table) ]] && lowe_case $table || echo $aimsdb).sql
      dbtl="$aimsdb $(s_r_r $extract)"

      while [[ ${f_time} -le $n_time ]]; do
        startDate=$(s_d tt $f_time)
        f_time=$(s_d -d 1 -b $(s_d ymd $f_time))
        endDate=$(s_d tt $([[ $f_time -ge $n_time ]] && echo $n_time || echo $f_time))
        # 执行sql文件并将数据写入本地存储数据的目录
        mysql -P3306 -h${hosts} -u${user} -p${passwd} -D${fromdb} -s -N -e "$(sed "s/table/$(high_case $table)/; s/startDate/$startDate/g; s/endDate/$endDate/g" $extract)" >> $(stor_data tsv)
        # 判断命令是否执行成功
        [[ $? == 0 ]] && succ "$dbtl" "$hosts $thdt $startDate $endDate  抽取成功" || erro "$dbtl" "$hosts $thdt $startDate $endDate  抽取失败"
      done
      edit_time
    } &
  elif [[ $type == mongodb ]]; then # MongoDB类型来源
    {
      # 针对个别需要的文件单独执行，否则以与目录相同的文件执行
      extract=$extract_dir/$([[ $(ls $extract_dir | grep .mongo$) =~ $(lowe_case $table) ]] && lowe_case $table || echo $aimsdb).mongo
      dbtl="$aimsdb $(s_r_r $extract)"

      while [[ ${f_time} -le $n_time ]]; do
        startDate=$(s_d tt $f_time)
        f_time=$(s_d -d 1 -b $(s_d ymd $f_time))
        endDate=$(s_d tt $([[ $f_time -ge $n_time ]] && echo $n_time ||  echo $f_time))
        # 执行sql文件并将数据写入本地存储数据的目录
        mongoexport --type=json -h ${hosts}:27017 -u ${user} -p ${passwd} -d ${fromdb} -c $(high_case $table) -q "$(sed "s/startDate/$startDate/g; s/endDate/$endDate/g" $extract)" | sed 's/{"$oid"://; s/},/,/' >> $(stor_data json)
        # 判断命令是否执行成功
        [[ $? == 0 ]] && succ "$dbtl" "$thdt $startDate $endDate  抽取成功" || erro "$dbtl" "$thdt $startDate $endDate  抽取失败"
      done
      edit_time
    } &
  fi
  p_opera
done < $imex_table


info '等待  extract.sh  的所有任务完成' '等待中..................................................'

# 等待所有任务完成
wait_jobs

info '等待  extract.sh  的所有任务完成' '已完成！！！！！！！！！！！！！！！！！！！！'

# 删除存储数据的目录下的空目录及空文件
for dir in $(tree -afi --noreport $data_direct | grep -v mysql); do
  {
    if [[ -d $dir && $(ls $dir) == '' ]]; then
      rm -rf $dir && info "$(s_l_l $(s_l_r $(s_l_r $(s_l_r $dir)))) $(s_r_r $dir)" '删除空文件夹'
    elif [[ -f $dir && ! -s $dir ]]; then
      rm -f $dir && info "$(s_l_l $(s_l_r $(s_l_r $(s_l_r $dir)))) $(s_r_r $dir)" '删除空文件'
    fi
  } &
done


# 等待并行执行结束
wait_jobs


info '从各数据源获取数据' '执行结束'


