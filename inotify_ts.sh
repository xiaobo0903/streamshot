#!/bin/bash
#设定本机的IP地址和端口号，供截图服务在调用TS文件截图时使用；
redip=192.168.1.81
ip=192.168.1.10
port=80
tspath=/tmp/live/
inotifywait -mrq --timefmt '%d/%m/%y %H:%M'  --format '%T %w %f %e'  --event close_write  --exclude '^(.*\.m3u8|.*\.bak|.*\.jpg)$' $tspath | awk -F' ' \
'{len=split($3, array, "/"); \
cmd= "redis-cli -h ""'$redip'"" set "array[len-2]"_"array[len-1]" http://""'$ip'"":""'$port'""/getts/"array[len-2]"/"array[len-1]"/"$4" ex 20 >/dev/null 2>&1" 
#print cmd;
system(cmd);
#now=systime();print now;

}'





