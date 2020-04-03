CREATE TABLE `log_services_status`
(
    `id`            varchar(64) NOT NULL,
    `service_name`  varchar(255),
    `event_time`    datetime,
    `event_id`      int(11),
    `event_info`    varchar(255),
    `service_group` varchar(255)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
