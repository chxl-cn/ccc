CREATE TABLE `loco_lrt`
(
    `locomotive_code` varchar(20) NOT NULL,
    `data_sort`       varchar(1)  NOT NULL,
    `last_time`       datetime,
    `id`              varchar(40),
    `g_id`            varchar(40),
    `g_last_time`     datetime,
    PRIMARY KEY (`locomotive_code`, `data_sort`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
