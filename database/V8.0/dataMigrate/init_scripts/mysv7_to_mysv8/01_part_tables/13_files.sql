DELIMITER ;
CREATE TABLE `log_request`
(
    `id`            VARCHAR(63) NOT NULL,
    `USER_NAME`     VARCHAR(127),
    `CLIENT_IP`     VARCHAR(127),
    `EVENT_ID`      VARCHAR(31),
    `SESSION_INFOS` VARCHAR(511),
    `URL`           VARCHAR(2047),
    `MAIN_URL`      VARCHAR(511),
    `REQUEST_TIME`  DATETIME,
    `COST_TIME`     INT(11)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


CREATE TABLE `log_services_status`
(
    `id`            VARCHAR(64) NOT NULL,
    `service_name`  VARCHAR(255),
    `event_time`    DATETIME,
    `event_id`      INT(11),
    `event_info`    VARCHAR(255),
    `service_group` VARCHAR(255)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


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