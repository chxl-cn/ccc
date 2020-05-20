CREATE TABLE `funpermission`
(
    `id`       varchar(100) NOT NULL,
    `masterid` varchar(100),
    `url`      varchar(100),
    `new`      decimal(16, 0),
    `mod`      decimal(16, 0),
    `del`      decimal(16, 0),
    `query`    decimal(16, 0),
    `funcode`  varchar(100)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
