--redis服务器的访问地址
--local ip = "127.0.0.1"
--local port = 6379

ip = ngx.var.red_ip
port = ngx.var.red_port+0
--截图保存临时地址，上传后就会删除，但需要保证Nginx进程需要有读写权限；
path= ngx.var.pic_path

--切割字符串
function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

--关闭redis数据库
local function close_redis(red)  
    if not red then  
        return  
    end  
    local ok, err = red:close()  
    if not ok then  
        ngx.status = 404
        ngx.say("close redis error : ", err)  
        ngx.exit(404) 
    end  
end  

--根据ts的访问地址，调用ffmpeg进行截图；
local function ffmpeg_shot(tsurl, appN, streamN)

    ngx.log(ngx.ERR, "popen begin!")
    cmd = 'ffmpeg -y -i '..tsurl..' -f image2 -ss 0 -t 0.001 -vframes 1 '..path..appN..'_'..streamN..'.jpg >/dev/null 2>&1&& redis-cli -h '..ip..' -p '..port..
    ' -x set '..appN..'_'..streamN..'_pic <'..path..appN..'_'..streamN..'.jpg >/dev/null 2>&1 && redis-cli -h '..ip..' -p '..port..
    ' expire '..appN..'_'..streamN..'_pic 20 >/dev/null && rm -rf '..path..appN..'_'..streamN..'.jpg&'
    ngx.log(ngx.ERR, ip)
    ngx.log(ngx.ERR, port)
    ngx.log(ngx.ERR, path)
    ngx.log(ngx.ERR, cmd)
    t = io.popen(cmd)
    --ngx.log(ngx.ERR, "popen end1!")
    --popen系统调用是非阻塞，所以会存在没有截图完成时即返回结果的现像，为了保证在截图后进行后续操作，进程增加了300ms的延时，不够精确，但应该能够满足大部分需求；
    ngx.sleep(0.3)
    --ngx.log(ngx.ERR, "sleep end1!")
end

local function getKey(p_app, p_stream)

    redkey = p_app.."_"..p_stream
    return redkey
end
  
--获得uri,uri的
local uri = ngx.var.uri

local sp =  mysplit(uri, "/")
if sp == nil then
    ngx.status = 404
    ngx.say("url error!", err)
    return ngx.exit(404) 
    
end
local app= sp[1]
local stream= sp[2]

local redis = require("resty.redis")  
  
--创建实例  
local red = redis:new()  
--设置超时（毫秒）  
red:set_timeout(1000)  

--建立连接  
local ok, err = red:connect(ip, port)  
if not ok then  
    close_redis(red)  
    ngx.status = 404
    ngx.say("connect to redis error : ", err)  
    return ngx.exit(404) 
end 

ngx.header.content_type = "text/plain"

--根据appName和streamName来提取当前ts片的访问地址，然后再进行截图；
local tsurl, err = red:get(getKey(app, stream))  

if tsurl == ngx.null then  
    close_redis(red)  
    ngx.status = 404
    ngx.say("The tsurl not exit!: ", err)  
    return ngx.exit(404) 
end  

ffmpeg_shot(tsurl, app, stream)

--截图完成后根据appName和streamName对于截图的内容进行提取；

local img, err = red:get(getKey(app, stream.."_pic"))
close_redis(red)
if img == ngx.null then  
    
    ngx.status = 404
    ngx.say("The picture not exit!")  
    return ngx.exit(404) 

else
    ngx.header.content_type = "image/jpeg"
    ngx.say(img)  
    ngx.exit(200)
end
