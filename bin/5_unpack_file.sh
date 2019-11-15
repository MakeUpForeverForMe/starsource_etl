#!/bin/bash -e

. $(dirname "${BASH_SOURCE[0]}")/../lib/env.sh

info 'UnPack File' '打包执行开始'


[[ $dayhour == $unpack_time ]] && {
  for dir in $data_direct/*/*.$yearmonth_last; do
    [[ ! -d $dir ]] && continue

    info "$(s_d ft $n_time)  $dir" 'Tar Start'
    # tar -cf $dir.tar $dir 2>> $info_log
    [[ $? == 0 ]] && succ "$(s_d ft $n_time)  $dir.tar" '打包成功' || erro "$(s_d ft $n_time)  $dir.tar" '打包成功'


    info "$(s_d ft $n_time)  $dir.tar" 'Bzip2 Start'
    # bzip2 $dir.tar 2>> $info_log
    [[ $? == 0 ]] && succ "$(s_d ft $n_time)  $dir.tar.bz2" '压缩成功' || erro "$(s_d ft $n_time)  $dir.tar.bz2" '压缩成功'

  done
  # rm $old_info_log $output_home_dir/*.$year_sixth_month.bz2 2>> $info_log
} || warn 'UnPack Time_UnArrived' '时间未到      不能执行打包任务'


info 'UnPack File' '打包执行结束'


