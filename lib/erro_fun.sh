#!/bin/bash -e


erro_log(){
  info "TailF $info_log" '监控日志，是否有错误产生'
  tail -F -n 0 $info_log | grep --line-buffered -wiE 'error|erro' >> $erro_log
}
