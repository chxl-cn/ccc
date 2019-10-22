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
    AesFactory.cs
```C#
    // AES加解密

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
    // 提供跨数据库访问的API

```

