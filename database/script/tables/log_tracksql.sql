CREATE TABLE `log_tracksql`
(
    `logid`       VARCHAR(63) NOT NULL,
    `Application` VARCHAR(255),
    `Stack`       VARCHAR(1023),
    `SqlInfo`     VARCHAR(4000),
    `TrackDesc`   VARCHAR(2048),
    `RequestTime` DATETIME,
    `CostTime`    INT(11),
    PRIMARY KEY (`logid`),
    KEY `RequestTime` (`RequestTime`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;