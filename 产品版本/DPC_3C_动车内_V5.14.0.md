3C Version Publish - V5.14.0动车对内数据终端
=================
  
版本修订
-----------------------------------

日期 | 作者 |  说明
-|-|-
2020/02/04| xuyong| add

目标
-----------------------------------

1. 实现hbase的db替换方案，解决hbase的运维难题；网站性能优化；APP接口。

风险
-----------------------------------

1. 本次计划远程办公，可能存在延期风险。

开发计划
-----------------------------------

SPRINT1:2020/02/04-2020/02/21

版本服务/组件列表
-----------------------------------

服务/组件 | 版本号 | 版本日期 | 是否更新 |升级内容
-|-|-|-|-
 动车对内数据终端网站| DPC_3C_I_V5.14.0 |2020/02/21| 有 |1、详情页上下一条数据的性能优化：通过缓存列表数据实现；2、性能监控页面优化，需要改数据提供的API；3、动车3C手机APP接口；4、解决分布式部署部分功能不可用（比如先由服务器生成地址给前端，再由前端下载）
 3C辅助工具| 3CUtil_V3.1 |2020/02/21| 有 |提供db替换hbase的迁移功能
 3C解析文件集中收集服务| FileCollector_V1.2 |2020/02/21| 有 |基于标准json提供db存储适配（胥义）
 动车对内解析服务| 3CDataInterface_D_5.6.0 |2020/02/21| 有 |更新3C公用组件，提供适配
 车次信息计算服务| traininfo_V1.0 |2019/10/16| 无 |
 车次信息现场接收服务| traininfo-receive_V1.0 |2019/10/16| 无 |
 SYN转发服务| C3SynAPI_V1.1 |2020/02/21| 有 |更新3C公用组件，提供适配
 转发服务| 3CTransmit_5.9.0 |2020/02/21| 有 |更新3C公用组件，提供适配
 主动检测时间计算服务|GpsTimeParser_V1.1.1 |2019/10/16| 无  |
 生成主动检测请求任务服务| RelayFileTask_V1.3|2019/10/16| 无 |
 请求车载主动检测数据服务| CreateFileTask_V1.3 |2019/10/16| 无 |
 3C主动检测数据解析、转发服务| 3COriDataProc_V1.1.0 |2020/02/21| 有 |更新3C公用组件，提供适配
 3C缺陷报告生成服务| CreateDoc_V2.3 |2020/02/21| 有 |更新3C公用组件，提供适配
 3C数据解析WebAPI接口| DPC_3C_Parser_WebAPI_V3.2.1 |2020/02/21| 有 |修复BUG
 AI消息消费服务|AI_MQConsumerService_V2.0|2019/12/24| 无 |
 AI智能机WebAPI| AiWebAPI_V2.1 |2020/01/16| 无 |
 3C解析监控服务| 3CMonoitor_3.2.0|2019/12/24| 无 |
 云转发服务| 3CDataTransmitterBroker_V1.5.0 |2019/12/13| 无 |

动车对内数据终端网站 - DPC_3C_I_V5.14.0
-----------------------------------

1. 版本号
DPC_3C_I_V5.14.0
2. 更新内容
    1. 详情页上下一条数据的性能优化：通过缓存列表数据实现，具体实现可能有变更（王政远）
    2. 性能监控页面优化，需要改数据提供的API（田喜霞）
    3. 动车3C手机APP接口（春节临时版本升级正式版本,新需求王政远）
    4. 解决分布式部署部分功能不可用（比如先由服务器生成地址给前端，再由前端下载）（王政远）

3. 配置变更
    1. web.config增加图片代理配置，以适配手机APP接口

```xml
<!-- 是否开启图片代理：开启后将通过ImageProxyHandler代理下载后再输出 -->
<add key="EnableImageProxy" value="false" />
```

3C辅助工具 - 3CUtil
-----------------------------------

/

3C解析文件集中收集服务| FileCollector
-----------------------------------

1. 版本号
FileCollector_V1.2
2. 更新内容
    1. 基于标准报警文件的路径JSON规范提供db存储适配

动车对内解析服务 - 3CDataInterface_D
-----------------------------------

1. 版本号
3CDataInterface_D_5.6.0
2. 更新内容
    1. 更新3C公用组件，提供适配

车次信息计算服务 - traininfo
-----------------------------------

/

SYN转发服务-C3SynAPI
-----------------------------------

1. 版本号
C3SynAPI_V1.1
2. 更新内容
    1. 更新3C公用组件，提供适配

转发服务-3CTransmit
-----------------------------------

1. 版本号
3CTransmit_5.9.0
2. 更新内容
    1. 更新3C公用组件，提供适配

主动检测时间计算服务-GpsTimeParser
-----------------------------------

/

生成主动检测请求任务服务-RelayFileTask
-----------------------------------

/

请求车载主动检测数据服务-CreateFileTask
-----------------------------------

/

3C主动检测数据解析、转发服务-3COriDataProc
-----------------------------------

1. 版本号
3COriDataProc_V1.1.0
2. 更新内容
    1. 更新3C公用组件，提供适配

3C缺陷报告生成服务-CreateDoc_V2.3
-----------------------------------

1. 版本号
CreateDoc_V2.3
2. 更新内容
    1. 更新3C公用组件，提供适配

3C数据解析WebAPI接口-DPC_3C_Parser_WebAPI
-----------------------------------

1. 版本号
DPC_3C_Parser_WebAPI_V3.2.1
2. 更新内容
    1. 修复按日期查询只有当天的统计记录

AI消息消费服务-AI_MQConsumerService
-----------------------------------

/

AI智能机WebAPI-AiWebAPI
-----------------------------------

/

3C解析监控服务-3CMonoitor
-----------------------------------

/

云转发服务-3CDataTransmitterBroker
-----------------------------------

/

接口/模型
-----------------------------------

```c#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SinoRail.DPC.Model
{
    /// <summary>
    /// fastDfs alarm file BO
    /// </summary>
    [Serializable]
    public class FastDfsAlarmFileBO
    {
        /// <summary>
        /// id
        /// </summary>
        public string Id { get; set; }
        /// <summary>
        /// 报警ID
        /// </summary>
        public string AlarmId { get; set; }
        /// <summary>
        /// device id
        /// </summary>
        public string DeviceId { get; set; }
        /// <summary>
        /// raise time
        /// </summary>
        public string RaiseTime { get; set; }
        /// <summary>
        /// 图片地址类型:0 本地路径 1 fastDfs 2 url路径
        /// </summary>
        public int ImageLocation { get; set; } = 1;
        /// <summary>
        /// mv2
        /// </summary>
        public string[] Mv2Images { get; set; }
        /// <summary>
        /// mv3
        /// </summary>
        public string[] Mv3Images { get; set; }
        /// <summary>
        /// mv4
        /// </summary>
        public string[] Mv4Images { get; set; }
        /// <summary>
        /// 机车irv,动车dlv生成的红外图片
        /// </summary>
        public string[] IrvImages { get; set; }
        /// <summary>
        /// 机车irv,动车dlv生成的透视图片
        /// </summary>
        public string[] IrvPImages { get; set; }
        /// <summary>
        /// 原始文件
        /// </summary>
        public List<FastDfsFileInfo> OriginalFiles { get; set; }
        /// <summary>
        /// FastDfs alarm file BO
        /// </summary>
        public FastDfsAlarmFileBO()
        {
            OriginalFiles = new List<Model.FastDfsFileInfo>();
        }
        /// <summary>
        /// 数据对象转换为业务对象
        /// </summary>
        /// <param name="dfsFileDO"></param>
        /// <returns></returns>
        public static FastDfsAlarmFileBO Parse(FastDfsFileDO dfsFileDO)
        {
            Dictionary<string, string> images = new Dictionary<string, string>();
            Dictionary<string, string> orgFiles = new Dictionary<string, string>();
            string deviceId = string.Empty;
            string raiseTime = string.Empty;

            foreach (string column in dfsFileDO.Columns.Keys)
            {
                string[] columnArray = column.Split(':');
                string faimily = columnArray[0]; //族
                string cellName = columnArray[1];  //列名
                string cellValue = dfsFileDO.Columns[column];//列值：文件路径
                switch (faimily)
                {
                    case "alarmImgFiles":
                        images.Add(cellName, cellValue);
                        break;
                    case "alarmOrgFiles":
                        orgFiles.Add(cellName, cellValue);
                        break;
                    case "alarmInfo":
                        switch (cellName)
                        {
                            case "deviceID":
                                deviceId = cellValue;
                                break;
                            case "raisedTime":
                                raiseTime = cellValue;
                                break;
                        }
                        break;
                    default:
                        break;
                }
            }
            FastDfsAlarmFileBO dfsFileBO = new FastDfsAlarmFileBO();
            dfsFileBO.Id = dfsFileDO.Id;
            dfsFileBO.RaiseTime = raiseTime;
            dfsFileBO.DeviceId = deviceId;
            dfsFileBO.bindImages(images);
            dfsFileBO.BindOriginalFiles(orgFiles);
            return dfsFileBO;
        }

        /// <summary>
        /// 绑定原始文件
        /// </summary>
        /// <param name="files"></param>
        protected void BindOriginalFiles(Dictionary<string, string> files)
        {
            foreach(string key in files.Keys)
            {
                AddOriginalFile(key, files[key]);
            }
        }

        /// <summary>
        /// 绑定数据：将{fileType,fileUrl}数据按类型分组
        /// </summary>
        /// <param name="files">columnName,url</param>
        protected void bindImages(Dictionary<string,string> files)
        {
            Dictionary<int, string> _mv2Images = new Dictionary<int, string>();
            Dictionary<int, string> _mv3Images = new Dictionary<int, string>();
            Dictionary<int, string> _mv4Images = new Dictionary<int, string>();
            Dictionary<int, string> _irvImages = new Dictionary<int, string>();
            Dictionary<int, string> _irvpImages = new Dictionary<int, string>();

            foreach(string key in files.Keys)
            {
                string url = files[key];
                string type = key.Substring(0, 3);
                int index = 0;
                #region 分组分类
                switch (type)
                {
                    case "MV2":
                        index = int.Parse(key.Substring(4));
                        _mv2Images.Add(index, url);
                        break;
                    case "MV3":
                        index = int.Parse(key.Substring(4));
                        _mv3Images.Add(index, url);
                        break;
                    case "MV4":
                        index = int.Parse(key.Substring(4));
                        _mv4Images.Add(index, url);
                        break;
                    //case "dlv":
                    case "IRV":
                        int pIndex = key.IndexOf("_P");
                        if (pIndex == -1)
                        {
                            index = int.Parse(key.Substring(3));
                            _irvImages.Add(index, url);
                        }
                        else
                        {
                            index = int.Parse(key.Substring(3, pIndex - 3));
                            _irvpImages.Add(index, url);
                        }
                        break;
                }
                #endregion
            }

            #region 排序
            Mv2Images = _mv2Images.OrderBy(o => o.Key).ToDictionary(o => o.Key, o => o.Value).Values.ToArray();
            Mv3Images = _mv3Images.OrderBy(o => o.Key).ToDictionary(o => o.Key, o => o.Value).Values.ToArray();
            Mv4Images = _mv4Images.OrderBy(o => o.Key).ToDictionary(o => o.Key, o => o.Value).Values.ToArray();
            IrvImages = _irvImages.OrderBy(o => o.Key).ToDictionary(o => o.Key, o => o.Value).Values.ToArray();
            IrvPImages = _irvpImages.OrderBy(o => o.Key).ToDictionary(o => o.Key, o => o.Value).Values.ToArray();
            _mv2Images = null;
            _mv3Images = null;
            _mv4Images = null;
            _irvImages = null;
            _irvpImages = null;
            #endregion
        }

        private void AddOriginalFile(string fileType, string url)
        {
            FastDfsFileInfo dfsFile = new FastDfsFileInfo();
            dfsFile.FileType = fileType;
            dfsFile.Url = url;
            OriginalFiles.Add(dfsFile);
        }

        private string GetFileType(string url)
        {
            int index = url.LastIndexOf('.');
            string type = url.Substring(index + 1);
            return type;
        }
    }
}
```

数据存储的JSON格式规范
-----------------------------------

```json
{
	"Id": "20200111104452_9_CRH380B-5883_710_0_B.scs",
	"AlarmId": "F4895c51a49e149ef932b6fd0bc5b7001",
	"DeviceId": "CRH380B-5883",
	"RaiseTime": "2020-01-11 10:44:52",
	"ImageLocation": 1,
	"Mv2Images": ["group0/M01/BE/55/CgICqV4ZtyaAb0K2AASSt-Qpxdk411.JPG", "group0/M01/BE/55/CgICqV4ZtyaAXvO4AASPuGWsqdc062.JPG", "group0/M01/BE/55/CgICqV4ZtyaAMddTAATeAYylutE842.JPG", "group0/M01/BE/55/CgICqV4ZtyaAASV4AASyrkqS9aw301.JPG", "group0/M01/BE/55/CgICqV4ZtyaAJ3ACAAStVUMGCzw420.JPG", "group0/M01/BE/55/CgICqV4ZtyaAO2mSAAS_jzXsWtk050.JPG", "group0/M01/BE/55/CgICqV4ZtyaAGQFOAASzU8wxbJ0825.JPG", "group0/M01/BE/55/CgICqV4ZtyaABM0mAASbonJec_c224.JPG", "group0/M01/BE/55/CgICqV4ZtyaAdG1YAASeRfEXsaI508.JPG", "group0/M01/BE/55/CgICqV4ZtyaASXS4AATel3pKdT0887.JPG", "group0/M01/BE/55/CgICqV4ZtyaAeGwpAATT096jvOY713.JPG", "group0/M01/BE/55/CgICqV4ZtyaAba0qAATTwXS9k5Q519.JPG"],
	"Mv3Images": ["group0/M01/BE/55/CgICqV4ZtyaAJ1CrAAJujhda45g444.JPG", "group0/M01/BE/55/CgICqV4ZtyaAYpX1AAJxO5CvcHY075.JPG", "group0/M01/BE/55/CgICqV4ZtyaAR6EAAAKVtmtJIMQ261.JPG", "group0/M01/BE/55/CgICqV4ZtyaAPPOyAAKqzRmTtCE298.JPG", "group0/M01/BE/55/CgICqV4ZtyaAMw5TAAKg91fBE4c021.JPG", "group0/M01/BE/55/CgICqV4ZtyaAaVHJAAKeQp5lP_0894.JPG", "group0/M01/BE/55/CgICqV4ZtyaAVxL5AAKdUf3pq_I516.JPG", "group0/M01/BE/55/CgICqV4ZtyaAaRSpAAKVqr2ekSA462.JPG", "group0/M01/BE/55/CgICqV4ZtyaABb61AAKSS9XjR2o854.JPG", "group0/M01/BE/55/CgICqV4ZtyaADuOfAAKVI1vyfMY063.JPG", "group0/M01/BE/55/CgICqV4ZtyaAC7cWAAKP-skgPRw197.JPG", "group0/M01/BE/55/CgICqV4ZtyaAP79iAAKP5hwMNyY489.JPG", "group0/M01/BE/55/CgICqV4ZtyaAOiTNAAKJcxsBN7k541.JPG", "group0/M01/BE/55/CgICqV4ZtyaAADzmAAKJtvvACdQ290.JPG", "group0/M01/BE/55/CgICqV4ZtyeATIlaAAKBUQ6oZ1Y972.JPG", "group0/M01/BE/55/CgICqV4ZtyeADw-2AAKC-5DurLk104.JPG", "group0/M01/BE/55/CgICqV4ZtyeAMgaDAAKCYWAp_JA804.JPG", "group0/M01/BE/55/CgICqV4ZtyeAAtB5AAKwG6p03d0259.JPG", "group0/M01/BE/55/CgICqV4ZtyeAcYsSAAKsI7ksta8950.JPG"],
	"Mv4Images": [],
	"IrvImages": ["group0/M01/BE/55/CgICqV4ZtyaAW_IrAAHUBMWVdJM044.JPG", "group0/M01/BE/55/CgICqV4ZtyaATt3RAAHNdFJ6QrY342.JPG", "group0/M01/BE/55/CgICqV4ZtyaAGcfcAAHxx9b3AsE605.JPG", "group0/M01/BE/55/CgICqV4ZtyaAdFuZAAH0PkVlvc4157.JPG", "group0/M01/BE/55/CgICqV4ZtyaACKnKAAHUccpYPvU283.JPG", "group0/M01/BE/55/CgICqV4ZtyaAS1QUAAHJ5jJOFPU490.JPG", "group0/M01/BE/55/CgICqV4ZtyaAW5PHAAHaMw3Mqt8184.JPG", "group0/M01/BE/55/CgICqV4ZtyaAf92sAAHrC8YvKM4176.JPG", "group0/M01/BE/55/CgICqV4ZtyaALz2hAAHLO7hWc9U231.JPG", "group0/M01/BE/55/CgICqV4ZtyaAfSuOAAHRWkThztw113.JPG", "group0/M01/BE/55/CgICqV4ZtyaAKDoAAAHlo4rL-1I082.JPG"],
	"IrvPImages": ["group0/M01/BE/55/CgICqV4ZtyaAab_tAABhINW0SM8095.JPG", "group0/M01/BE/55/CgICqV4ZtyaAObq4AABgMEtWqfw153.JPG", "group0/M01/BE/55/CgICqV4ZtyaAQCWHAABjrwmIdV0347.JPG", "group0/M01/BE/55/CgICqV4ZtyaAKWfxAABi75abCBU967.JPG", "group0/M01/BE/55/CgICqV4ZtyaAMy1oAABc6V3R3Lk519.JPG", "group0/M01/BE/55/CgICqV4ZtyaAOFSCAABg1DwFX3U437.JPG", "group0/M01/BE/55/CgICqV4ZtyaANC47AABhn-AlFx0507.JPG", "group0/M01/BE/55/CgICqV4ZtyaACGgKAABhe6s5LSE323.JPG", "group0/M01/BE/55/CgICqV4ZtyaAEfnyAABekHws_SQ774.JPG", "group0/M01/BE/55/CgICqV4ZtyaATImeAABd45FTnxE767.JPG", "group0/M01/BE/55/CgICqV4ZtyaAPzpsAABg-mgVGw4584.JPG"],
	"OriginalFiles": [{
		"Url": "group0/M01/BE/54/CgICqV4ZtxuAPyG9ACBmJeDWWdg2147.mv",
		"FileType": "2mv"
	}, {
		"Url": "group0/M01/B1/42/CgICqF4ZtxuAbnFUAAAFFN72XJU.mv.IDX",
		"FileType": "2mvIDX"
	}, {
		"Url": "group0/M01/B1/42/CgICqF4ZtxuAWeSgABx00nCazws5424.mv",
		"FileType": "3mv"
	}, {
		"Url": "group0/M01/BE/54/CgICqV4ZtxyAeIyuAAAH0L0ZOFc.mv.IDX",
		"FileType": "3mvIDX"
	}, {
		"Url": "group0/M01/BE/54/CgICqV4ZtxyAaSpvAAQ38TFjvKk5235.mv",
		"FileType": "4mv"
	}, {
		"Url": "group0/M01/B1/42/CgICqF4ZtxuAJZC-AAAEsO2t4T4.mv.IDX",
		"FileType": "4mvIDX"
	}, {
		"Url": "group0/M01/BE/54/CgICqV4ZtxuAJH1LAAefoH15tcs128.dlv",
		"FileType": "dlv"
	}, {
		"Url": "group0/M01/B1/42/CgICqF4ZtxuAH8yPAAAEsBY9hvU.dlv.ID",
		"FileType": "dlvIDX"
	}, {
		"Url": "group0/M01/B1/43/CgICqF4ZtxuAHeR6AAAMEk9Ry1o154.scs",
		"FileType": "scs"
	}]
}
```
