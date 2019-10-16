# streamshot

截取一个视频流的截图： ffmpeg -ss 0 -i n.ts -y -f image2 -vframes 1 xxx.jpg 
安装inotfy 建立目录监控程序，通过监控ts的切片来进行截图（切片的生成时间如为5秒，则5秒钟截一次图；
经测试截图的处理时间为20毫秒左右(720p); 截图后文件就放到切片目录中供播放器进行访问； 
建立快速截图的访问服务； 每次截图完成后，把相关的图片上传到redis中进行保存，并且删除本地的文件名称；
上传的图片设置的有效时间为24小时；24小时后自动删除；（redis) 图片上传采用的是python中的 
安装python环境: pip install redis Image 把截图放入到redis中，通过nginx的lua服务进行处理； 
nginx的访问服务可以通过直播服务的访问名来调用相应的图片内容；
直播的访问名称换成http的地址+shot.jpg,即可返回相应的图片内容； 
图片的自由变换: 图片的地址加size=*x240; 即按变换比例进行处理；
