3C doc - 实时提图服务WebAPI
=================
  
版本修订
-----------------------------------
+ 2019/10/28  author:xuyong  add  


设计思路
-----------------------------------
略 

类设计
-----------------------------------
### 类图
略
### 类说明
略  


接口调用
-----------------------------------
javascript json调用
```javascript 
    ajax调用，参考swagger:http://192.168.1.251:8091/swagger/index.html
```
通过ID解析图像传入参数说明
```c#
    public class RequestParam
    {
        /// <summary>
        /// 会话ID[随机字符串]
        /// </summary>
        public string SessionId { get; set; }

        /// <summary>
        /// Alarm ID
        /// </summary>
        public string Id { get; set; }
        /// <summary>
        /// Alarm RaiseTime
        /// </summary>
        public DateTime InputTime { get; set; }
    }
```
通过scs文件名解析图像传入参数说明
```c#
    public class RequestParam
    {
        /// <summary>
        /// 会话ID[随机字符串]
        /// </summary>
        public string SessionId { get; set; }

        /// <summary>
        /// SCS文件名
        /// </summary>
        public string RealFileName { get; set; }
    }
```
MvResult结果
```c# 
    public class MvResultInfo
    {
        /// <summary>
        /// 是否成功
        /// </summary>
        public bool Success { get; set; }
        /// <summary>
        /// 临时会话ID
        /// </summary>
        public string SessionId { get; set; }
        /// <summary>
        /// 帧数量
        /// </summary>
        public int FrameCount { get; set; }
        /// <summary>
        /// 图像宽度
        /// </summary>
        public int Width { get; set; }
        /// <summary>
        /// 高度
        /// </summary>
        public int Height { get; set; }

        /// <summary>
        /// 消息
        /// </summary>
        public string Message { get; set; }
    }
```

获取MV4图像代码
```c#
    string url = "http://192.168.1.232:8090/api/Mv4";
    string imageUrl = "http://192.168.1.232:8090/api/GetImage";
    string jsonTmp = "{  \"sessionId\": \"$1\",  \"fileName\": \"\",  \"realFileName\": \"$2\",  \"idxFileName\": \"\",  \"available\": true }";
    string json = jsonTmp.Replace("$1", sid).Replace("$2", scs).Replace("$2", scs);
    var result = SinoRail.Common.Utils.HttpUtil.Post(url, json, null);
    var obj = Newtonsoft.Json.JsonConvert.DeserializeObject<MvResultInfo>(result);
    // 生成11张图片
    for(int i=0;i<obj.FrameCount;i++)
    {
        string imgPath = $"{imageUrl}/{sid}/{i}";
    }
```
