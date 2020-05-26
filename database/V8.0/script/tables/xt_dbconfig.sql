CREATE TABLE `xt_dbconfig`
(
    `name`           varchar(31) NOT NULL,
    `usetype`        int(11) COMMENT '数据库用途：0仅读 1仅写 2读写，一般实时库仅写，历史库仅读，特殊情况下实时库可以读写',
    `usedays`        int(11) COMMENT '使用天数：实时库配置',
    `startdate`      datetime,
    `enddate`        datetime,
    `createtime`     datetime,
    `IsEncryptionDb` int(11) COMMENT '是否加密',
    `dbtype`         varchar(15) COMMENT '数据库类型:mysql',
    `dbconn`         varchar(511) COMMENT '数据库连接串',
    `dbinfo`         varchar(511) COMMENT '描述',
    `searchindex`    int(11) COMMENT '检索顺序',
    PRIMARY KEY (`name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
