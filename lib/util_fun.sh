#!/bin/bash -e


oracle_export(){ [[ $# == 5 ]] && sqoop eval --connect jdbc:oracle:thin:@${1}:1521:${4} --username ${2} --password ${3} -e "${5}" || echo '参数不正确' $#; }


# 将一行KV数据解析为变量与值 declare -g设置为全局变量
kv_get(){
  for line_field in $1; do
    line_fields=($(e_a $line_field))
    declare -g ${line_fields[0]}=${line_fields[1]}
  done
}

imex_analyze(){
  line_analyze=($(v_a "${1}"))
  imex="${line_analyze[0]}"
  type="${line_analyze[1]}"
  hosts="${line_analyze[2]}"
  user="${line_analyze[3]}"
  passwd="${line_analyze[4]}"
  fromdb="${line_analyze[5]}"
  aimsdb="${line_analyze[6]}"
  table="${line_analyze[7]}"
  start_time="${line_analyze[8]}"
  last_time="${line_analyze[9]}"
  partition="${line_analyze[10]}"
}

truly_table(){ tbl=($(p_a "$table")); echo $(lowe_case ${tbl[0]}); }

hive_tbl(){
  db="$aimsdb"
  real_table=$(truly_table)
  if [[ $type == local ]]; then
    file_type=json
  elif [[ $type == mongodb ]]; then
    file_type=json
  elif [[ $type == mysql ]]; then
    file_type=tsv
  fi
  dttb=${db}.${real_table}_${file_type}
}


# 根据是否需要分区，返回对应的目录，并格式化名称
# 需要传入文件格式、文件时间、表名(即子目录名)
stor_data(){
  tbl=$(lowe_case ${3:-$table})
  file_date=${2:-$startDate}
  [[ $partition == - ]] && echo $aims_dir/$tbl.$1 || {
    dir=$aims_dir/$tbl.${file_date:0:6}
    exist_dir $dir
    echo $dir/$tbl.${file_date:0:8}.$1
  }
}


# 按表修改时间
# edit_time(){
#   sed -i "/$imex/{/${3:-$aimsdb}/{/${2:-$table}/s/$last_time/${1:-$start_time}/}}" $imex_table
#   # sed -n "/$imex/{/${3:-$aimsdb}/{/${2:-$table}/s/$last_time/${1:-$start_time}/p}}" $imex_table
#   [[ $? == 0 ]] && \
#   succ "${3:-$aimsdb}.${2:-$table} $last_time--${1:-$start_time}" '修改历史时间成功' || \
#   erro "${3:-$aimsdb}.${2:-$table} $last_time--${1:-$start_time}" '修改历史时间失败'

#   sed -i "/$imex/{/${3:-$aimsdb}/{/${2:-$table}/s/$start_time/$n_time/}}" $imex_table
#   # sed -n "/$imex/{/${3:-$aimsdb}/{/${2:-$table}/s/$start_time/$n_time/p}}" $imex_table
#   [[ $? == 0 ]] && \
#   succ "${3:-$aimsdb}.${2:-$table}  $start_time--$n_time" '修改开始时间成功' || \
#   erro "${3:-$aimsdb}.${2:-$table}  $start_time--$n_time" '修改开始时间失败'
# }

edit_time(){
  sed -i "/$imex/{/$hosts/{/${3:-$aimsdb}/{/${2:-$table}/s/$last_time/${1:-$start_time}/}}}" $imex_table
  # sed -n "/$imex/{/${3:-$aimsdb}/{/${2:-$table}/s/$last_time/${1:-$start_time}/p}}" $imex_table
  [[ $? == 0 ]] && \
  succ "${hosts}_${3:-$aimsdb}.${2:-$table} $last_time--${1:-$start_time}" '修改历史时间成功' || \
  erro "${hosts}_${3:-$aimsdb}.${2:-$table} $last_time--${1:-$start_time}" '修改历史时间失败'

  sed -i "/$imex/{/$hosts/{/${3:-$aimsdb}/{/${2:-$table}/s/$start_time/$n_time/}}}" $imex_table
  # sed -n "/$imex/{/${3:-$aimsdb}/{/${2:-$table}/s/$start_time/$n_time/p}}" $imex_table
  [[ $? == 0 ]] && \
  succ "${hosts}_${3:-$aimsdb}.${2:-$table}  $start_time--$n_time" '修改开始时间成功' || \
  erro "${hosts}_${3:-$aimsdb}.${2:-$table}  $start_time--$n_time" '修改开始时间失败'
}



# 判断是否存在目录，无则创建
exist_dir(){ [[ ! -d $1 ]] && mkdir -p $1; }


# 以变量值为变量输出其值
eval_echo(){ eval echo '$'"$1"; }


# 子参数解析(analy)
b_a(){ echo ${1//-/ }; } # 横杠 bar           b
c_a(){ echo ${1//:/ }; } # 冒号 colon         c
e_a(){ echo ${1//=/ }; } # 等号 equal         e
f_a(){ echo ${1//;/ }; } # 分号 fenhao        m
m_a(){ echo ${1//,/ }; } # 逗号 comma         m
p_a(){ echo ${1//./ }; } # 点   point         p
s_a(){ echo ${1//\// }; } # 斜杠 slash        s
u_a(){ echo ${1//_/ }; } # 下划线 underline   u
v_a(){ echo ${1//|/ }; } # 竖线 vertical      v


trim(){ echo $1 | sed 's/^\s*//; s/\s*$//'; }
trim_m(){ echo $1 | sed 's/^,*//; s/,*$//'; }


# 大小写转换
lowe_case(){ echo $1 | tr [A-Z] [a-z]; } # 小写
high_case(){ echo $1 | tr [a-z] [A-Z]; } # 大写


# 获取字符串的某一部位
# p：点，s：斜杠，m：逗号，u：下划线
p_r_l(){ echo ${1%.*}; }
p_l_r(){ echo ${1#*.}; }
s_r_l(){ echo ${1%/*}; }
s_l_r(){ echo ${1#*/}; }
m_l_r(){ echo ${1#*,}; }
m_r_l(){ echo ${1%,*}; }
u_l_r(){ echo ${1#*_}; }
u_r_l(){ echo ${1%_*}; }

p_l_l(){ echo ${1%%.*}; }
p_r_r(){ echo ${1##*.}; }
s_l_l(){ echo ${1%%/*}; }
s_r_r(){ echo ${1##*/}; }
m_l_l(){ echo ${1%%,*}; }
m_r_r(){ echo ${1##*,}; }
u_l_l(){ echo ${1%%_*}; }
u_r_r(){ echo ${1##*_}; }


# 获取文件名并拆分
split_name(){ p_a $(s_r_r $1); }


wait_jobs(){
  for pid in $(jobs -p); do
    wait $pid
  done
}


# 并行限制
p_opera(){
  pids=(${pids[@]:-} $!)
  while [[ ${#pids[@]} -ge $p_num ]]; do
    pids_old=(${pids[@]})   pids=()
    for p in "${pids_old[@]}";do
      [[ -d "/proc/$p" ]] && pids=(${pids[@]} $p)
    done
    num=${#pids[@]}
    sleep 0.01
  done
}


