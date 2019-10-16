#!/bin/bash
inotifywait -mrq --timefmt '%d/%m/%y %H:%M'  --format '%T %w %f %e'  --event close_write  --exclude '^(.*\.m3u8|.*\.bak|.*\.jpg)$' /tmp/live | while read date time path file event
do
    #echo $file $event
    bash ./shot.sh ${path} ${file}&
done
