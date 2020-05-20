CREATE TABLE `trans_max_delay`
(
    `recv_dept_code` tinytext,
    `date_type`      tinyint(4),
    `start_time`     datetime,
    `end_time`       datetime,
    `delay_hours`    int(11),
    `set_time`       datetime,
    `stop_time`      datetime,
    `is_valid`       varchar(1)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
