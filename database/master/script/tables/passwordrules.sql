CREATE TABLE `passwordrules`
(
    `id`          varchar(100),
    `rulename`    varchar(20),
    `rulevalue`   varchar(200),
    `rulecomment` varchar(200),
    `time`        datetime
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
