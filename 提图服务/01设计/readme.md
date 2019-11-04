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
解析并获取本地 DLV图像
```c#
    string url = "http://192.168.1.251:8091/api/dlv";
    string imageUrl = "http://192.168.1.251:8091/api/GetImage";
    string jsonTmp = "{  \"sessionId\": \"$1\",  \"fileName\": \"\",  \"id\": \"$2\",  \"inputTime\": \"$3\",  \"available\": true }";
    string json = jsonTmp.Replace("$1", sid).Replace("$2", alarmId).Replace("$3", raiseTime);
    var result = SinoRail.Common.Utils.HttpUtil.Post(url, json, null);
    var obj = Newtonsoft.Json.JsonConvert.DeserializeObject<MvResultInfo>(result);
    // 生成11张图片
    for(int i=0;i<obj.FrameCount;i++)
    {
        string imgPath = $"{imageUrl}/{sid}/{i}";
    }
```
解析并获取本地 Ori图像
```c#
    string url = "http://192.168.1.251:8091/api/dlv";
    string imageUrl = "http://192.168.1.251:8091/api/dlv/GetOri";
    string jsonTmp = "{  \"sessionId\": \"$1\", \"id\": \"$2\",  \"realFileName\": \"$3\",  \"available\": true }";
    string json = jsonTmp.Replace("$1", sid).Replace("$2", taskQueueId).Replace("$3", dlvFileName);
    var result = SinoRail.Common.Utils.HttpUtil.Post(url, json, null);
    var obj = Newtonsoft.Json.JsonConvert.DeserializeObject<MvResultInfo>(result);
    // 生成11张图片
    for(int i=0;i<obj.FrameCount;i++)
    {
        string imgPath = $"{imageUrl}/{sid}/{i}";
    }
```

解析并获取本地DLV文件区域范围内最高温度
```c#
    string url = "http://192.168.1.251:8091/api/dlv";
    string imageUrl = "http://192.168.1.251:8091/api/dlv/GetTemp";
    string jsonTmp = "{  \"sessionId\": \"$1\", \"id\": \"$2\",  \"inputTime\": \"$3\", \"frameIndex\": \"1\",   \"x1\": \"0\",  \"y1\": \"0\",  \"x2\": \"100\",  \"y2\": \"100\" }";
        string json = jsonTmp.Replace("$1", sid).Replace("$2", alarmId).Replace("$3", raiseTime);
    var result = SinoRail.Common.Utils.HttpUtil.Post(url, json, null);
    // result.maxTemp 返回最高温度

```

解析并获取fastDFS DLV图像
```c#
    string url = "http://192.168.1.251:8091/api/dlv";
    string imageUrl = "http://192.168.1.251:8091/api/GetImage";
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
解析并获取fastDFS MV图像
```c#
    string url = "http://192.168.1.251:8091/api/Mv4";
    string imageUrl = "http://192.168.1.251:8091/api/GetImage";
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
