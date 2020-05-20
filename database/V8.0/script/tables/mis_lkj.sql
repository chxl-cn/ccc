CREATE TABLE `mis_lkj`
(
    `id`           varchar(128) NOT NULL,
    `lkj_code`     varchar(128) NOT NULL,
    `routing_code` varchar(128),
    `routing_no`   decimal(16, 0),
    `area_no`      decimal(16, 0),
    `station_no`   decimal(16, 0),
    `station_name` varchar(32),
    `line_code`    varchar(16),
    `line_name`    varchar(16),
    `line_no`      decimal(8, 0),
    `direction`    varchar(20),
    `bureau_code`  varchar(16),
    `bureau_name`  varchar(32),
    `create_time`  datetime,
    PRIMARY KEY (`lkj_code`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
