CREATE TABLE `event_exec_log`
(
    `event_name` varchar(100),
    `start_time` datetime(6),
    `end_time`   datetime(6),
    `stat_code`  varchar(5),
    `msg`        text
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
