ffmpeg -re -fflags +genpts -stream_loop -1 -i ./a.mov \
-c copy -f flv rtmp://localhost/live/0 \
-c copy -f flv rtmp://localhost/live/1 \
-c copy -f flv rtmp://localhost/live/2 \
-c copy -f flv rtmp://localhost/live/3 \
-c copy -f flv rtmp://localhost/live/4 \
-c copy -f flv rtmp://localhost/live/5 \
-c copy -f flv rtmp://localhost/live/6 \
-c copy -f flv rtmp://localhost/live/7 \
-c copy -f flv rtmp://localhost/live/8 \
-c copy -f flv rtmp://localhost/live/9
