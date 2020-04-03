CREATE TABLE `log_request`
(
    `id`            varchar(23) NOT NULL,
    `USER_NAME`     varchar(63),
    `CLIENT_IP`     varchar(127),
    `EVENT_ID`      varchar(31),
    `SESSION_INFOS` varchar(255),
    `URL`           varchar(511),
    `MAIN_URL`      varchar(511),
    `REQUEST_TIME`  datetime,
    `COST_TIME`     int(11)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
