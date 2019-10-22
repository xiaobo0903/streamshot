local function close_redis(red)  
    if not red then  
        return  
    end  
    local ok, err = red:close()  
    if not ok then  
        ngx.say("close redis error : ", err)  
    end  
end  

local function getKey(p_app, p_stream)

    redkey = p_app.."_"..p_stream
    return redkey
end
  
--获得url的参数，在nginx接收到请求后，把app和stream都获得后按参数方式放到链接后面；
local args = ngx.req.get_uri_args()

local app= args["app"]
local ch= args["stream"]

local redis = require("resty.redis")  
  
--创建实例  
local red = redis:new()  
--设置超时（毫秒）  
red:set_timeout(1000)  
--建立连接  
local ip = "127.0.0.1"  
local port = 6379  
local ok, err = red:connect(ip, port)  
if not ok then  
    ngx.say("connect to redis error : ", err)  
    ngx.exit(404)
    return close_redis(red)  
end 

ngx.header.content_type = "image/jpeg"

--调用API获取数据，因为redis中的value定时时间为30秒，当30秒钟没的接收到新的截图后，则清空记录，所以会出现value不存的错误；  
local resp, err = red:get(getKey(ch, app))  
if not resp then  
    ngx.say("The picture not exit!: ", err)  
    ngx.exit(404)
    return close_redis(red)  
end  

close_redis(red)

if resp == ngx.null then  
    
    ngx.say("The picture not exit!")  
    ngx.exit(404)

else
    ngx.say(resp)  
    ngx.exit(200)
end
