CREATE TABLE `version_hist`
(
    `versionno`  varchar(50) NOT NULL,
    `memo`       varchar(2000),
    `createtime` datetime,
    PRIMARY KEY (`versionno`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
