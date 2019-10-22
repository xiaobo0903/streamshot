#!/bin/bash
inotifywait -mrq --timefmt '%d/%m/%y %H:%M'  --format '%T %w %f %e'  --event close_write  --exclude '^(.*\.m3u8|.*\.bak|.*\.jpg)$' /tmp/live/ | awk -F' ' \
'{len=split($3, array, "/"); \
cmd= "ffmpeg -ss 0 -t 0.001 -i "$3$4" -y -f image2 -vframes 1 "$3$4".jpg >/dev/null 2>&1 &&" \
"redis-cli -h localhost -x set "array[len-2]"_"array[len-1]" <"$3$4".jpg >/dev/null 2>&1 &&" \
"redis-cli -h localhost expire "array[len-2]"_"array[len-1]" 600 >/dev/null 2>&1 && " \
"rm -rf "$3$4".jpg &";
#print cmd;
system(cmd);
#now=systime();print now;
}'
#system("ffmpeg -ss 0 -i "$3$4" -y -f image2  -vframes 1 "$3$4".jpg >/dev/null 2>&1;&&"\
#"redis-cli -h localhost set "array[len-2]"_"array[len-1]" <"$3$4".jpg;&& rm -rf "$3$4".jpg")}'
 
