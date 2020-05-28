3C Version Publish - V8.0.0
=================
  
版本修订
-----------------------------------

日期 | 作者 |  说明
-|-|-
2019/11/8|xuyong| add：V7.0
2019/11/27|xuyong| modify
2019/12/10|xuyong| modify
2020/03/02|xuyong| version : V7.1.1
2020/03/09|xuyong| version : V8.0

需求概述
-----------------------------------

基于mysql V7.1版本，依据2020/3/4动车3C性能讨论结果为指导，从下面的几方面需求考虑：

1. 统一模型：主要是alarm，c3_sms
2. 读写分离:热数据写到实时库，通过工具同步到历史库
3. 应用层:控制请求实现系统的自我保护
4. 内存数据库应用
5. 中间表设计
6. mysql的性能要求
7. 对内需求

目标
-----------------------------------

期望目标：设计容量500台车，每天10万条报警，72万条状态日志；100人同时在线处理报警数据；各种峰值按照设计参数的1.2倍计算。

总体设计思路
-----------------------------------

通过模型重构、分库分表和部分业务重构后，alarm/c3_sms的查询SQL都是单表查询，预计只要mysql服务器硬件性能能满足一定要求，是可以支持这个数据量业务的。  

参考：

1. [加密解密数据保护方案](../OutNext/数据安全加密和解密详细设计.md)  
2. [MySQL统一模型和性能提升方案](../OutNext/MySQL统一模型解决方案.md)  
3. [MySQL数据库模型详情](../Components/01Design)  
4. [3C性能问题分析_V8.0技术方案和开发计划](../OutNext/3C性能问题分析_V8.0技术方案和开发计划.mmap)  

开发计划
-----------------------------------

1. SPRINT1: 2020/03/16 - 2020/04/03 对外Mysql性能提升：统一模型，读写分离等性能问题
2. SPRINT2:对内网站需求，手机APP；将对内oralce升级至mysql版本；

版本服务/组件列表
-----------------------------------
  
服务/组件 | 版本号 |  是否更新 |升级内容
-|-|-|-
 云转发| 3CDataTransmitterBroker_V1.4.1 | 无 |-
 3C数据接收服务| FileReceiveWeb_V2.2.0 | 有 | 增加日志管理功能，增加日志nlog日志打印，增加新的票据认证，旧票据认证key过短
 现场解析服务| 3CDataInterfaceSite_V4.1.3 | 有 |模型重构，提供统一的alarm访问组件
 动机车对外数据终端网站| DPC_3C_O_8.0.0 | 有 |统一模型，读写分离,SQL优化
 3C缺陷报告生成服务| CreateDoc_V2.4.4 | 有 |统一模型，重构报表的消息通信逻辑，支持分布式部署；config文件参数优化；
 3C数据解析WebAPI接口| DPC_3C_Parser_WebAPI_V3.3.0 | 有|统一模型，读写分离；支持redis做数据缓存，支持分布式部署。
 转发服务| 3CTransmit_5.11.3 | 有 |模型重构，trans_data表优化。
 迁移工具| TransData_V2.1 | 有 |功能优化，方便运维；编辑后迁移界面支持增删改单条保存，类似Navicat编辑界面；提供加解密界面；提供基础数据分类导出；数据导出支持批量执行，生成一个bat文件。
 数据同步工具| - | 有 |DBA工具，支持实时库同步至历史库；如果是单库部署不需要这个工具。

开发须知
-----------------------------------

集成环境：

mysql数据库：Database=dbv711;Data Source=192.168.3.90;User Id=dbv711;Password=123456Aa;CharSet=utf8;port=3306  
redis:10.2.2.168:6379,password=,connectTimeout=1000,connectRetry=1,syncTimeout=10000  
提图服务:http://10.2.2.167:9091（需要把原始文件放到对应的虚拟目录）  
公用组件源代码：http://gitlab.gt.com/3C/public/dpc.git  
mysql版本项目组：http://gitlab.gt.com/3C/outnext  
V8.0网站：http://gitlab.gt.com/3C/outnext/dpc_3c_onext_web.git  为了避免开发人员提交bin文件，bin目录被排除了的；第一次编译时将_bin改名成bin或拷贝至bin目录下，再编译  

公用组件：

关于Parameter和config配置，原则上config除数据库外，其他配置到mis_parameter,公用参数context=public，支持context重写（比如可配置成：public,3c_context），避免运维重复配置

```csharp
        /// <summary>
        /// 参数扩展（建议各服务通过扩展方法补充自定义的参数）
        /// </summary>
        public static class ParameterExtend
        {
            /// <summary>
            /// 扩展参数列表
            /// </summary>
            /// <param name="t"></param>
            /// <returns></returns>
            public static string GetP1(this SinoRail.DPC.C3.Globals.ParameterCollection t)
            {
                var p = t.GetParameter("dfs.address");
                return p == null ? "" : p.ParamValue;
            }
        }

        [Test]
        public void GetParameterTest()
        {
            // 全局初始化
            string contexts = "public,3C_DataCenter";
            SinoRail.DPC.C3.Globals.ParameterCollection.Initiate(contexts.Split(','));
            // 访问公用参数
            var address1 = SinoRail.DPC.C3.Globals.ParameterCollection.Current.DlvParserAddress;
            // 访问自定义扩展参数
            var p1 = SinoRail.DPC.C3.Globals.ParameterCollection.Current.GetP1();
        }
```

分库适配代码：通过公用适配工厂类创建数据库Context或者dbConnection

```csharp
        /// <summary>
        /// 通过时间创建dbContext
        /// </summary>
        [Test]
        public void CreateContextTest()
        {
            var svr = DataBaseAdapter.Instance;
            bool succ = false;
            DateTime start = DateTime.Now.AddDays(-1000);
            DateTime end = DateTime.Now;
            using (var context = svr.CreateDataContext(start, end))
            {
                if(context.GetConnection().Connection.State == System.Data.ConnectionState.Open)
                    succ = true;
            }
            Assert.IsTrue(succ);

        }
        /// <summary>
        /// 通过时间创建dbConnection
        /// </summary>
        [Test]
        public void CreateDefaultConnTest()
        {
            var svr = DataBaseAdapter.Instance;
            bool succ = false;
            DateTime start = DateTime.Now.AddDays(-1000);
            DateTime end = DateTime.Now;
            using (var conn = svr.CreateDbConnection(start, end))
            {
                if(conn.State == System.Data.ConnectionState.Open)
                    succ = true;
            }
            Assert.IsTrue(succ);
        }
```

数据保护组件使用代码

```csharp
        /// <summary>
        /// 获取报警加密信息
        /// </summary>
        [Test]
        public void GetAlarmInfoTest()
        {
            var svr = SafeguardManager.Current;
            SinoRail.DPC.C3.FileStore.FileContext context = new SinoRail.DPC.C3.FileStore.FileContext();
            string scsName = "20191028142047_9_CRH5G-5215_510_0_B.scs";
            string id = "Fa7b0d584c21647aab150aba7878dd8d2";
            DateTime date = context.GetFileInfo(scsName).Item1;
            var info = svr.GetAlarmInfo(id,date);
            Assert.IsNotNull(info);
        }
```

1.对内解析服务问题/分析/设计/任务
-----------------------------------

性能问题：目前无显著性能问题

需求：基于新模型重构

问题/需求分析：基于新模型重构，数据入库时报警序列化后写入Redis

性能指标：

1. 状态日志：500*1.2条/分钟
2. 报警数据：84条/分钟

设计：/

任务/计划：SPRINT2

2.现场解析服务问题/分析/设计/任务
-----------------------------------

性能问题：铁科院写数据的压力会比较大

需求：基于新模型重构

问题/需求分析：基于新模型重构，数据入库时报警序列化后写入Redis；铁科院部署可以采用多服务部署解决写数据问题。

性能指标：

1. 状态日志：500*1.2条/分钟
2. 报警数据：84条/分钟

设计：/

任务/计划：SPRINT1

1. 基于模型重构
2. 数据入库时报警序列化后写入Redis

3.转发服务问题/分析/设计/任务
-----------------------------------

性能问题：对内的数据库DBA跟踪发现trans_data相关的SQL有性能问题

需求：/

问题/需求分析：trans_data表的数据量过大引起的查询和更新都很慢，通过业务逻辑优化最小trans_data的存储量

性能指标：

1. 状态日志：500*1.2条/分钟
2. 报警数据：84条/分钟

设计：

1. trans_data按报警和日志，实时和历史拆分成4张表

任务/计划：SPRINT1

1. 代码重构适配新的表模型
2. 转发成功移动至历史表
3. 转发超时移动至历史表

4.提图服务问题/分析/设计/任务
-----------------------------------

性能问题：技术部API红外提图和曝光性能问题

需求：支持分库查询

问题/需求分析：技术问题红外提图和曝光暂时不优化

性能指标：/

设计：/

任务/计划：SPRINT1

1. 重构API，支持分库查询
2. 关联任务：网站调用接口

5.报表服务问题/分析/设计/任务
-----------------------------------

性能问题：代码中通过while循环查询alarm/aux的待处理数据

需求：支持分库查询

问题/需求分析：代码中通过while循环查询alarm/aux的待处理数据，可能会牺牲无效的资源；可以通过Redis消息交互机制解决。

性能指标：/

设计：

1. 网站请求导出报表时，将报警ID添加至Redis消息队列
2. 报表服务刷新Redis消息队列，逐个生成报表，更新ID的报表状态
3. 网站刷新Redis中的ID报表状态，返回报表地址

任务/计划：SPRINT1

1. 重构报表服务消息机制
2. 基于新模型重构报表数据的查询代码
3. 关联任务：网站调用接口

6.网站问题/分析/设计/任务
-----------------------------------

性能问题：

1. 报警列表查询慢，DBA监控大SQL经常出现
2. 报警详情上一条/下一条慢
3. 报警确认或取消时比较慢
4. 设备状态日志列表打开慢
5. 日报/周报/月报统计比较慢

需求：/

问题/需求分析：

1. 报警查询相关的问题，通过和DBA分析，系统慢主要原因还是报警相关的查询SQL复杂导致服务器CPU和磁盘IO高，通过表模型重构后该业务查询都是单表查询可以解决问题
2. 报警上一条/下一条功能可以通过Redis缓存当前页数据，减少数据库查询
3. 报警详情页面确认时，跟踪代码发现一个逻辑存在多次数据库连接，需要重构代码减少数据库交互；另外通过Redis缓存热数据，可以直接从Redis获取详情数据
4. 设备状态列表页默认打开就出数据，一般用户不需要看这个数据，都需要调整查询条件重新查询，可以关闭默认查询或限制条件
5. 日报/周报/月报统计可以通过调度每日统计到中间表

性能指标：

1. 网站页面期望响应指标：<1S，最低指标1~3S
2. 详情页响应指标：fastdfs图片<1S，实时提图1~3S
3. 报警查询列表：100人*1请求/分钟
4. 报警详情：100人*10请求/分钟

设计：

1. 数据库模型重构
2. 基于报警新模型重构业务代码，所有alarm列表查询SQL禁止关联alarm_aux,alarm_img
3. 通过公用API获取报警实体
4. 报表导出：见报表服务逻辑

任务/计划：SPRINT1

1. 公用Alarm相关模型重构和访问API
2. 报警列表查询代码重构
3. 报警详情/报警确认
4. 报警上一条/下一条
5. 设备状态数据
6. DBA日报/周报/月报统计中间表输出
7. 日报/周报/月报统计功能
8. 重复报警
9. 其他

迁移工具 - TransData_V1.2
-----------------------------------

1. 功能优化，便于运维升级维护

同步工具/方案 - DBSyn_V1.0
-----------------------------------

1. 由楚学亮研究提供
2. 支持实时库将数据同步至历史库
3. 历史数据的迁移

提图服务 - DPC_3C_Parser_WebAPI_V3.3.0
-----------------------------------

配置变更

```xml
  // 默认为空，仅单点部署；redis支持分布式部署，分布式部署ImageCacheTimeOut可配置更长时间
  "ImageCacheStore": "redis",
```

升级内容：

1. 支持redis分布式部署，提图后的图像以bytes存储到redis，任何提图节点都可以访问
2. 支持实时库将数据同步至历史库

SQL脚本
-----------------------------------

```sql
create table train6c.xt_dbconfig
(
   name                 varchar(31) not null,
   usetype              int(1) comment '数据库用途：0实时库 1当年库 2历史库',
   usedays              int comment '使用天数：实时库配置',
   startdate            date,
   enddate              date,
   createtime           datetime,
   IsEncryptionDb       int(1) comment '是否加密',
   dbtype               varchar(15) comment '数据库类型:mysql',
   dbconn               varchar(511) comment '数据库连接串',
   dbinfo               varchar(511) comment '描述',
   primary key (name)
);
INSERT INTO ``(`name`, `usetype`, `usedays`, `startdate`, `enddate`, `createtime`, `IsEncryptionDb`, `dbtype`, `dbconn`, `dbinfo`) VALUES ('default_db', 0, 366000, NULL, '2040-03-12', '2020-03-12 13:18:17', 0, 'mysql', 'Database=train6c;Data Source=10.2.2.169;User Id=root;Password=123456Aa;CharSet=utf8;port=3306', '实时库');
```
