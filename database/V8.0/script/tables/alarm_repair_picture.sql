CREATE TABLE `alarm_repair_picture`
(
    `id`                  VARCHAR(100) DEFAULT NULL,
    `alarm_id`            VARCHAR(100) NOT NULL,
    `wait_repair_picture` TEXT,
    `done_repair_picture` TEXT,
    PRIMARY KEY (`alarm_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
;