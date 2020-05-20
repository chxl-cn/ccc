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
