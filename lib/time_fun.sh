#!/bin/bash -e


# 当前时间
curr_time(){ s_d; }


# 经常用的时间格式
ymd(){ s_d ymd $1; }


# 遍历两日期间的每一天（传入基础时间。格式为年月日等）
diff_day(){ s_d -d ${2:-1} -b $1 ymd; }


# 持续时间/秒
during(){
  u=$(( $1 - ${2:-$1} ))
  s=$(( $u % 60 )) u=$(( $u / 60 ))
  k=$(( $u % 60 )) u=$(( $u / 60 ))
  h=$(( $u % 24 )) d=$(( $u / 24 ))
  printf '%d天%02d时%02d分%02d秒' $d $h $k $s
}


# 返回$1型日期格式的日期，$2输入秒级时间
# 索引 $OPTIND
s_d(){
  # getopts在第二次调用时不匹配选项，其他参数也出错。因为OPTIND初始化时为1，改变后不会自动重新赋值
  OPTIND=1
  # :b:d:f: 其中开头的冒号是：有选项但是没有参数时防止报错；参数后的冒号代表这个选项必须有参数
  while getopts :b:d:f: opt; do
    case $opt in
      (b) secon_arg=$(date -d "$OPTARG" +%s) ;;
      (d) date_diff="$OPTARG" ;;
      (f) date_format="$OPTARG" ;;
      (:) echo "请添加参数: -$OPTARG" ;;
      (?) echo "选项未设置: -$OPTARG" ;;
      (*) echo "未知情况" ;;
    esac
  done
  # $OPTIND 存储选项及选项参数，占两位。其他参数占一位。
  # 通过shift $(($OPTIND - 1))的处理，$*中就只保留了除去选项内容的参数，可以在其后进行正常的shell编程处理。
  shift $(($OPTIND - 1))
  # 秒数转14位日期时间(total简写tt)
  [[ $1 == 'tt'  ]] && format='%Y%m%d%H%M%S'
  # 当时年月日
  [[ $1 == 'ymd' ]] && format='%Y%m%d'
  # 秒数转日期时间
  [[ $1 == 'ft'  ]] && format='%F %T'
  # 当时年月
  [[ $1 == 'ym'  ]] && format='%Y%m'
  # 当时月日
  [[ $1 == 'md'  ]] && format='%m%d'
  # 当天的天及小时
  [[ $1 == 'dh'  ]] && format='%d%H'
  # 秒数转日期
  [[ $1 == 'f'   ]] && format='%F'
  # 本年的第几天
  [[ $1 == 'j'   ]] && format='%j'
  # 今年是哪一年
  [[ $1 == 'y'   ]] && format='%Y'
  # 今年的第几月
  [[ $1 == 'm'   ]] && format='%m'
  # 本月的第几天
  [[ $1 == 'd'   ]] && format='%d'
  # 当天的第几小时
  [[ $1 == 'h'   ]] && format='%H'
  # 此时的第几分钟
  [[ $1 == 'k'   ]] && format='%M'
  # 此分的第几秒
  [[ $1 == 's'   ]] && format='%S'
  # 今年的第几周
  [[ $1 == 'w'   ]] && format='%W'
  # 本周的第几天
  [[ $1 == 'u'   ]] && format='%u'

  # 执行命令
  # date_diff(d) 时间间隔  date_format(f)  时间格式  base_time(b) 基础时间
  date -d "${date_diff:-0} ${date_format:-day} $(date -d@${2:-${secon_arg:-$(date +%s)}} +'%F %T')" +"${format:-%s}"
}
