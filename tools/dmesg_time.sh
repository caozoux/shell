#!/bin/bash
 
if [ $# -ne 1 ];then
    echo "input an dmesg time"
    exit 1
fi
 
unix_time=`echo "$(date +%s) - $(cat /proc/uptime | cut -f 1 -d' ') + ${1}" | bc`
echo ${unix_time}
date -d "@${unix_time}" '+%Y-%m-%d %H:%M:%S'
