3C for TikKe - V1.0.0
=================
  
版本修订
-----------------------------------

日期 | 作者 |  说明
-|-|-
2019/12/26|xuyong| add

目标
-----------------------------------

基于铁科V6.0~V7.0中间拉出分支实现铁科新接收方案

开发计划
-----------------------------------

SPRINT1: 2019/12/25 - 2020/01/15 基本实现一阶段目标

版本服务/组件列表
-----------------------------------
  
服务/组件 | 版本号 |  是否更新 |升级内容
-|-|-|-
 车载服务| V1 |  有 | 李潇
 文件收集服务| FileCollector_v1.2 | 有 |胥义，增加铁科网络状态文件收集
 铁科网络状态文件解析服务| DPC_3C_Parser_TKNet_v1.0.0| 有 |解析铁科网络状态文件，入库（张海涛）
 回传数据包生成服务| DPC_3C_ReturnPackets_v1.0.0| 有 |回传数据包生成（张海涛）
 分析服务器-udp指令应答服务| DPC_3C_UdpCommunication_v1.0.0| 有 |接收【铁科接收服务器】的udp指令，并应答。Kafka消息通知分析服务（徐勇）
 分析服务器-车载数据包分析服务| DPC_3C_Parser_DevicePacketsAnalysis_v1.0.0| 有 |"解析车载数据包，生成标准数据包 ，提取夹带信息，更新已入库信息"（党刚明）
 应用服务器-标准数据包监听服务| DPC_3C_Watch_StandardPackets_v1.0.0| 有 |监听标准数据包，加入kafka队列（胥义）
 应用服务器-标准数据包解析服务| DPC_3C_Parser_StandardPackets_v1.0.0| 有 |接受kafka消息，解析标准数据包，入库，关键信息加密（王政远）
 应用服务器-3C数据接收与分析终端| DPC_3C_TKWeb_1.0.0| 有 |配合改造后的功能调整

动车对内数据终端网站 - DPC_3C_TKWeb_1.0.0
-----------------------------------

1. 版本号
DPC_3C_TKWeb_1.0.0
2. 更新内容
    1. 数据库结构重构
    2. 所有报警和状态数据查询相关修改
    3. 报警图片呈现

3. 配置变更

文件收集服务 - FileCollector_v1.2
-----------------------------------

铁科网络状态文件解析服务 - DPC_3C_Parser_TKNet_v1.0.0
-----------------------------------

回传数据包生成服务 - DPC_3C_ReturnPackets_v1.0.0
-----------------------------------

udp指令应答服务 - DPC_3C_UdpCommunication_v1.0.0
-----------------------------------

车载数据包分析服务 - DPC_3C_Parser_DevicePacketsAnalysis_v1.0
-----------------------------------

应用服务器-标准数据包监听服务 - DPC_3C_Watch_StandardPackets_v1.0
-----------------------------------

应用服务器-标准数据包解析服务 - DPC_3C_Parser_StandardPackets_v1.0
-----------------------------------

附件
-----------------------------------