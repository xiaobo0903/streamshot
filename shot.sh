#!/bin/bash

path=$1
file=$2

ffmpeg  -ss 0 -i ${path}${file} -y -f image2  -vframes 1 ${path}${file}.jpg >/dev/null 2>&1

arr_app=(${path//\// })
arr_stream=(${file//./ })
app=${arr_app[-1]}
stream=${arr_stream[0]}
key=${app}_${stream}
#echo ${path}${file}
python ldjpg_redis.py ${path}${file}.jpg $key

rm -rf ${path}${file}.jpg
