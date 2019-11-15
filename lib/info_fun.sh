#!/bin/bash -e

# 颜色设置
f_c(){ echo "\033[${2:-${color:-0}}m%${1:-0}s\033[0m"; }

# info 日志
# 输入 $1: 任务名称 $2: 其他需要输出的参数 $3: 任务类型
# 返回 '时间 [INFO] 用户名@主机名 持续时长 分步时长 任务名称 其他需要输出的参数'
# 工具 :
# s_d         ./starsource/lib/time_fum.sh
# curr_time   ./starsource/lib/time_fum.sh
# during      ./starsource/lib/util_fun.sh
# split_dire  ./starsource/lib/util_fun.sh
info(){
  # getopts在第二次调用时不匹配选项，其他参数也出错。因为OPTIND初始化时为1，改变后不会自动重新赋值
  OPTIND=1
  while getopts :f: opt; do
    case $opt in
      (f) info_type="$OPTARG" ;;
      (:) echo "请添加参数: -$OPTARG" ;;
      (?) echo "选项未设置: -$OPTARG" ;;
      (*) echo "未知情况" ;;
    esac
  done

  shift $(($OPTIND - 1))

  c_time=$(curr_time)
  cur_t=$(s_d 'ft' $c_time)

  dur_t=$(during ${c_time} ${n_time})
  dur_s=$(during ${c_time} ${t_time:-$c_time})
  t_time=${c_time}

  job_n=(${1:-})

  [[ ${#job_n[@]} == 2 ]] && job_n=$(printf '%-15s %20s' ${job_n[0]} ${job_n[1]}) || job_n="${1:-}"

  [[ $OPTIND > 1 ]] && style=$info_type || style=INFO

  if [[ $style == ERRO ]]; then
    color=31
  elif [[ $style == WARN ]]; then
    color=35
  else
    color=32
  fi

  printf \
  "$(f_c -19)  $(f_c 5 34)@$(f_c -3 34)  [ $(f_c -4) ]  总计 $(f_c -11) 分步 $(f_c -11)  $(f_c -35 33)    $(f_c -0 36)\n" \
  "$cur_t" $user_name $host_name $style $dur_t $dur_s  "$job_n"  "$2"
}


succ(){ info -f 'SUCC' "$1" "$2"; }

warn(){ info -f 'WARN' "$1" "$2"; }

erro(){ info -f 'ERRO' "$1" "$2"; }

