3C doc - 基于JSON格式的报警文件存储规范
=================
  
版本修订
-----------------------------------

日期|作者 | 操作 |内容
-|-|-|-
2020/02/20 |xuyong |add | 初稿

用途
-----------------------------------

该文档用于描述3C报警所有相关文件的存储信息

格式
-----------------------------------

JSON，注意：每次保存数据前如果数据已经存在则要做结构更新

应用范围
-----------------------------------

3C文件收集服务，解析服务，转发服务，主动检测，网站和手机APP终端

数据库存储模型
-----------------------------------

ALARM_FILEINFO：报警文件存储信息  
ALARM_FILEINFO的字段信息如下:  
字段名称|是否主键 | 类型 | 是否允许为空 | 描述
-|-|-|-|-
ID|Y|NVARCHAR2(64)|N|主键
RAISETIME|N|DATE|Y|检测日期
FILEINFO|N|CLOB|Y|文件信息

JSON格式注释
-----------------------------------

```json
{
	"Id": "20200111104452_9_CRH380B-5883_710_0_B.scs",//SCS主键名称，必填
	"AlarmId": "F4895c51a49e149ef932b6fd0bc5b7001",//报警ID，非必填
	"DeviceId": "CRH380B-5883",//设备号，非必填
	"RaiseTime": "2020-01-11 10:44:52",//从scs名称中解析的日期，必填
	"ImageLocation": 1,//默认值1,1:fastdfs文件，0：本地地址
	"Mv2Images": [],//局部图片数组
	"Mv3Images": [],//全景图片数组
	"Mv4Images": [],//辅助图片，目前为空
	"IrvImages": [],//红外图片数组
    "IrvPImages": [],//灰度图片数组
    //OriginalFiles原始文件
	"OriginalFiles": [{
		"Url": "group0/M01/BE/54/CgICqV4ZtxuAPyG9ACBmJeDWWdg2147.mv",
		"FileType": "2mv"//局部
	}, {
		"Url": "group0/M01/B1/42/CgICqF4ZtxuAbnFUAAAFFN72XJU.mv.IDX",
		"FileType": "2mvIDX"
	}, {
		"Url": "group0/M01/B1/42/CgICqF4ZtxuAWeSgABx00nCazws5424.mv",
		"FileType": "3mv"//全景
	}, {
		"Url": "group0/M01/BE/54/CgICqV4ZtxyAeIyuAAAH0L0ZOFc.mv.IDX",
		"FileType": "3mvIDX"
	}, {
		"Url": "group0/M01/BE/54/CgICqV4ZtxyAaSpvAAQ38TFjvKk5235.mv",
		"FileType": "4mv"//辅助
	}, {
		"Url": "group0/M01/B1/42/CgICqF4ZtxuAJZC-AAAEsO2t4T4.mv.IDX",
		"FileType": "4mvIDX"
	}, {
		"Url": "group0/M01/BE/54/CgICqV4ZtxuAJH1LAAefoH15tcs128.dlv",
		"FileType": "dlv"//红外
	}, {
		"Url": "group0/M01/B1/42/CgICqF4ZtxuAH8yPAAAEsBY9hvU.dlv.ID",
		"FileType": "dlvIDX"
	}, {
		"Url": "group0/M01/B1/43/CgICqF4ZtxuAHeR6AAAMEk9Ry1o154.scs",
		"FileType": "scs"//scs
    }, {
		"Url": "group0/M01/B1/43/CgICqF4ZtxuAHeR6AAAMEk9Ry1o154.txt",
		"FileType": "txt"//text
    }, {
		"Url": "group0/M01/B1/43/CgICqF4ZtxuAHeR6AAAMEk9Ry1o154.tax",
		"FileType": "tax"//tax
    }
    ]
}
```

JSON格式示例
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
