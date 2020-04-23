3C Version Publish - V8.0.0
=================
  
版本修订
-----------------------------------

日期 | 作者 |  说明
-|-|-
2020/04/23|xuyong| add：V8.0

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

运行视图
-----------------------------------

/

dotnet 数据库访问统一开发规范
-----------------------------------

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

dotnet 统一配置开发规范
-----------------------------------

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

dotnet 保护数据访问规范
-----------------------------------

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
