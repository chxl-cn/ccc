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

目标
-----------------------------------

基于mysql V7.1版本，依据2020/3/4动车3C性能讨论结果为指导，从下面的几方面考虑：

1. 统一模型：主要是alarm，c3_sms
2. 读写分离:热数据写到实时库，通过工具同步到历史库
3. 应用层:控制请求实现系统的自我保护
4. 内存数据库应用
5. 中间表设计
6. mysql的性能要求
7. 对内需求

参考：

1. [加密解密数据保护方案](../OutNext/数据安全加密和解密详细设计.md)  
2. [MySQL统一模型和性能提升方案](../OutNext/MySQL统一模型解决方案.md)  

开发计划
-----------------------------------

1. SPRINT1: 2020/03/16 - 2020/04/03 对外Mysql性能提升：统一模型，读写分离等性能问题
2. SPRINT2:对内网站需求，手机APP；将对内oralce升级至mysql版本；

版本服务/组件列表
-----------------------------------
  
服务/组件 | 版本号 |  是否更新 |升级内容
-|-|-|-
 云转发| 3CDataTransmitterBroker_V1.4.1 | 无 |-
 3C数据接收服务| FileReceiveWeb_V2.1.2 | 无 |-
 现场解析服务| 3CDataInterfaceSite_V4.1 | 有 |模型重构
 动机车对外数据终端网站| DPC_3C_O_8.0.0 | 有 |统一模型，读写分离,SQL优化
 3C缺陷报告生成服务| CreateDoc_V1.9 | 有 |统一模型
 3C数据解析WebAPI接口| DPC_3C_Parser_WebAPI_V3.3.0 | 有|统一模型，读写分离
 转发服务| 3CTransmit_5.11.0 | 有 |模型重构
 迁移工具| TransData_V1.2 | 有 |功能优化，方便运维
 数据同步工具| - | 有 |DBA工具，支持实时库同步至历史库

公用组件 - SinoRail.DPC.3C_2.2
-----------------------------------

1. 提供数据库适配API：通过时间参数获取数据库地址
2. 原有数据保护组件支持分库查询
3. 更新组件SinoRail.DPC.3C

现场解析服务 - 3CDataInterfaceSite_V4.1·0
-----------------------------------

1. alarm报警模型重构和代码优化
2. c3_sms状态数据模型重构和代码优化
3. 更新组件SinoRail.DPC.3C

动机车对外数据终端网站 - DPC_3C_O_8.0.0
-----------------------------------

1. 更新组件SinoRail.DPC.3C
2. 报警模块
    1. alarm报警模型重构和代码优化
    2. alarm查询sql适配
    3. alarm分库的支持
3. 状态数据模块
    1. c3_sms报警模型重构和代码优化
    2. c3_sms查询sql适配
    3. c3_sms分库的支持
4. 控制请的自我保护
5. 存储过程更新（楚学亮）

3C缺陷报告生成服务 - CreateDoc_V1.9
-----------------------------------

1. 代码适配新模型
2. 更新组件SinoRail.DPC.3C，多数据库适配

转发服务 - 3CTransmit_5.11.0
-----------------------------------

1. c3_sms报警模型重构
2. alarm报警模型重构
3. Trans_data增删逻辑的优化，该表实质是一张热数据的临时表，尽量让该表的数据量最小化

3C数据解析WebAPI接口 - DPC_3C_Parser_WebAPI_V3.3.0
-----------------------------------

1. 统一模型
2. 数据分库适配（公用组件）

迁移工具 - TransData_V1.2
-----------------------------------

1. 功能优化，便于运维升级维护

同步工具/方案 - DBSyn_V1.0
-----------------------------------

1. 由楚学亮研究提供
2. 支持实时库将数据同步至历史库
3. 历史数据的迁移

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