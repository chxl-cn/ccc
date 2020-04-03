CREATE TABLE `special_workdays`
(
    `special_day` datetime NOT NULL,
    `date_type`   int(11),
    PRIMARY KEY (`special_day`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
