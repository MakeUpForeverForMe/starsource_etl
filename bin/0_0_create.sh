#!/bin/bash -e

. $(dirname "${BASH_SOURCE[0]}")/../lib/env.sh

crt_hql=$warehouse/create

for tbl in ${@:-$(ls $crt_hql)}; do
  {
    tbl=$(s_r_r $tbl)
    [[ $tbl =~ .hql ]] || { warn $tbl '不符合 hql 文件命名规范'; continue; }
    $beeline -f $crt_hql/$tbl
    [[ $? == 0 ]] && succ "$tbl" '建表成功' || erro "$tbl" '建表失败'
  } &
  p_opera
done

wait_jobs


