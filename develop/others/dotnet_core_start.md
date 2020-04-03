3C developer doc - dotnet core开发规范
=================
  
开发架构
-----------------------------------
![Image text](images/dotnet.png)

asp.net core 
-----------------------------------
  asp.net core mvc/api 
  

配置文件
-----------------------------------
### AppSetting.Json
    TODO:THE CODE 
```JSON
{
    //连接字符串
    "ConnectionStrings": {
    "IsEncryption": "0",
    "DbProvider": "Oracle.ManagedDataAccess.Client",
    "ConnectionString": "data source=192.168.1.250/bownet;password=123456Aa;user id=dtctest;"
    },
    "fastdfs.address": "192.168.1.231:22122,192.168.1.232:22122",
    "fastdfs.group": "group0",
    "hbase.dfsTable": "alarmTest",
    "hbase.address": "192.168.1.231:9090",
    "hbase.connectCount": "5",
    "redis.connectionString": "192.168.1.231:7001,192.168.1.231:7002,192.168.1.231:7003,192.168.1.231:7004,192.168.1.231:7005,192.168.1.231:7006,password=,connectTimeout=1000,connectRetry=1,syncTimeout=10000"
}

```
###  MIS_PARAMETER
TODO:数据库配置 
```DB
```

Git 版本使用
-----------------------------------
    1.git code  
    2.修改代码，commit to local,push to remote branch  
    3.测试通过后tag  version
    4.merge to master  


依赖注入开发规范
-----------------------------------
### 说明
    .Net Core MVC网站通过加载Startup.cs 时ConfigureServices(IServiceCollection services)注册类型后，通过Control构造函数注入。
    Windows服务或控制台通过“The Unity Container”组件实现注册。
    除了表示层统一注册实例类型，一般情况下其它层禁止直接实例化业务类，尽量通过构造函数初始化接口实例。  
    Data Access Layer：数据访问层，提供对数据库的访问，默认情况下通过Dapper组件访问数据库。  
    Business Logic Layer:业务逻辑层，提供产品业务逻辑的处理，业务逻辑层根据需要可以有多个业务逻辑组件，每个业务逻辑组件之间的边界要定义清楚，耦合度要尽量小，业务逻辑中需要的“日志记录”、“数据缓存”、“加密”、“异常处理”、“验证”等处理尽量使用公用组件集成。  
    Presentation Layer:呈现层，主要是Windows Service，MVC网站和WinForm，做程序界面的处理，呈现层中禁止有业务逻辑和数据访问的处理。界面展示风格和界面处理逻辑要符合公司的UI规范。  
    Model Objects:模型（实体）对象，是对软件产品中静态类型的映射，它也是面向对象编程的基础。它和数据库中的表有一定的映射关系，但绝对不是数据库的一张表就对应一个实体对象，在业务实体的定义上设计人员一定要考虑清楚。业务实体对象在数据访问层中填充数据，由“业务逻辑层”做相应的业务逻辑处理，并将处理结果返回到呈现层中进行呈现，所以模型对象都会被其它三层调用到。

### Sample Code
    Startup.cs
```c# 
    // 单个读取配置，支持对象序列化的读取
    string isEncryption = Configuration["ConnectionStrings:IsEncryption"];
    string dbProviderString = Configuration["ConnectionStrings:DbProvider"];
    string password = Configuration["ConnectionStrings:ConnectionString"];
```
```c# 
    // 注册数据访问组件
    services.AddSingleton(typeof(SinoRail.DataProvider.DataContextFactory), dbFactory);
    // 注册数据库访问类
    services.AddScoped(typeof(IAlarmDataAccess), typeof(AlarmDataAccess));
    services.AddScoped(typeof(IAlarmService), typeof(AlarmImpl));
    // 注册业务组件
    services.AddScoped(typeof(IAlarmParsedDataAccess), typeof(AlarmParsedDataAccess));
    services.AddScoped(typeof(IAlarmParsedService), typeof(AlarmParsedImpl));
```
    AlarmParsedController.cs
```c# 
    // 构造函数参数中初始化业务类，禁止跨层调用数据访问类，建议注入方式实例化对象
    public class AlarmParsedController : ControllerMaster
    {
            IAlarmParsedService _alarmService;
            /// <summary>
            /// AlarmParsed WEB API
            /// </summary>
            /// <param name="options">配置信息</param>
            public AlarmParsedController(IAlarmParsedService alarmService)
            {
                _alarmService = alarmService;
            }
    }
```
```c# 
    /// <summary>
    /// 报警解析数据类
    /// </summary>
    public class AlarmParsedImpl : IAlarmParsedService
    {
        IAlarmParsedDataAccess alarmDataAccess = null;

        // 构造函数初始化数据访问对象
        public AlarmParsedImpl(IAlarmParsedDataAccess dataAccess)
        {
            this.alarmDataAccess = dataAccess;
        }
    }
```
```c# 
    // 数据访问层统一使用DataContextFactory读写数据，DataContextFactory默认实现了大部分dapper访问接口
    public class AlarmParsedDataAccess : IAlarmParsedDataAccess
    {
        DataContextFactory DbContextFactory = null;
        SinoRail.DataProvider.Analyzer.AbsAnalyzer sqlAnalyzer = null;
        /// <summary>
        /// 报警数据访问类
        /// </summary>
        /// <param name="contextFactory"></param>
        public AlarmParsedDataAccess(DataContextFactory contextFactory)
        {
            this.DbContextFactory = contextFactory;
            sqlAnalyzer = SinoRail.DataProvider.Analyzer.SqlAnalyzerFactory.GetAnalyzer(DbContextFactory.DataProvider.DatabaseType);
        }
        
        // sql查询示例代码
        public List<object> GetSummary(DateTime begin, DateTime end)
        {
            List<object> lst = new List<object>();
            try
            {
                string query = sqlAnalyzer.Process(DBSqls.SUM_ALARM_PARSED_SUMMARY);
                using (IDataContext context = DbContextFactory.Create(true))
                {
                    lst = context.QueryList<object>(query, new { begin = begin, end = end });
                }
            }
            catch (Exception ex)
            {
                SinoRail.Common.Log.Logger.Current.Error(ex.StackTrace);
                lst = null;
            }
            return lst;
        }
    }

    // 统一定义sql
    public class DBSqls
    {
        // 报警查询
        public const string SUM_ALARM_PARSED_COSTTIME = @"
        select t.clientname,count(*) nums, round(avg((t.parsedtime-t.downtime)*(24*60*60)),0) avgtime  from log_consumer_alarm t 
        where t.collecttime>@begin and t.collecttime<@end and t.finalstatus=1
        group by t.clientname order by t.clientname
        ";
        public const string SUM_ALARM_PARSED_DAYS = @"
        select days, sum(nums) nums,sum(succ) succ,sum(fail) fail from(
        select to_char(t.collecttime,'yyyymmdd') days,1 nums,decode(t.status,200,1,0) succ,decode(t.status,200,0,1) fail  from log_consumer_alarm t 
        where t.collecttime>@begin and t.collecttime<@end 
        ) group by days order by days 
        ";
    }
``` 
### docker file
```
    FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
    EXPOSE 8091
    EXPOSE 8092
    COPY app/bin/Release/netcoreapp2.1/publish/ app/
    WORKDIR /app
    ENTRYPOINT ["dotnet", "C3DataProvider.dll"]
    #设置时区 ORACLE需要设置
    ENV TZ=Asia/Beijin
    RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
```
