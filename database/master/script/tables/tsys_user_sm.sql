CREATE TABLE `tsys_user_sm`
(
    `id`        varchar(40) NOT NULL,
    `loginid`   varchar(40) NOT NULL,
    `tel`       varchar(20),
    `name`      varchar(20),
    `usedcount` double,
    PRIMARY KEY (`loginid`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
