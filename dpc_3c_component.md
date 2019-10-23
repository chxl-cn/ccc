3C developer doc - dotnet core开发规范
=================
  
组件目录
-----------------------------------
+ SinoRail.Common            公用组件
+ SinoRail.DPC.C3            3C公用组件
+ SinoRail.Local            本地化类或语言包
+ SinoRail.Dataprovider            数据访问组件

SinoRail.Common
-----------------------------------
### 加解密组件
#### 提供AES加解密功能，MD5加密功能
    AES:  
    不同加密方案提供不同的KEY和VI
```C#
    // AES加解密
    var provider = CryptoProviderFactories.GetCryptoProvider(SinoRail.Common.Security.CryptoType.DbConnection);
    var cryptoString = "124aaaaaaaaaaaaaaaaaaaaaaaa";
    var s1 = provider.Encrypt(cryptoString);
    var s2 = provider.Decrypt(s1);
```
    Log:  
    日志模块
```C#
    // 程序启动初始化
    ILogWriter log4Writer = new Log4Writer("log4net.config");
    ILogWriter pipWriter = new CustomPipWriter();
    Logger.Init(new ILogWriter[] { log4Writer, pipWriter }, 2000);
    
    // error log
    Logger.Current.ErrorFormat("ErrorFormatTest {0} {1}。。。", "arg1", "arg2");

```
SinoRail.DPC.C3
-----------------------------------
### 报警对象数据安全组件
    AlarmDataCache.cs
```c# 
    // 报警数据缓存类

```

SinoRail.Dataprovider
-----------------------------------
### 数据访问组件
    DataContext.cs
```c# 
    // 一般情况下：DataContextFactory都是通过startup.cs注入
    // 实例化conn
    string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["DEFAULT"].ConnectionString;
    DbProviderFactory factory = DbProviderFactories.GetFactory("MySql.Data.MySqlClient");
    clientConnection = new DataContextProvider()
    {
        ConnectionString = connStr,
        DbProviderFactory = factory,
        ParameterChar = ":"
    };
    // 创建context
    DataContextFactory factory = new DataContextFactory(clientConnection);
    using (IDataContext context = factory.Create())
    {
        string sql = "select id from ALARM t where t.ID=:id ";
        AlarmDO alarm = context.QueryById<AlarmDO>(sql,id);
    }

```

