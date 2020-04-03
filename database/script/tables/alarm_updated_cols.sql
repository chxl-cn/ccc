CREATE TABLE `alarm_updated_cols`
(
    `id`          VARCHAR(40)  DEFAULT NULL,
    `group_name`  VARCHAR(100) DEFAULT NULL,
    `create_date` DATETIME     DEFAULT NULL,
    `user_code`   VARCHAR(50)  DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
;