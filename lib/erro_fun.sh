#!/bin/bash -e


erro_log(){
  info "TailF $info_log" &>> $info_log
  tail -F -n 0 $info_log | grep --line-buffered -wiE 'error|erro' >> $erro_log
}
