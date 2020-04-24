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