CREATE TABLE `virtual_dir_info`
(
    `id`                 varchar(35) NOT NULL,
    `virtual_dir_name`   varchar(60) NOT NULL,
    `strat_use_date`     datetime,
    `dir_type`           decimal(1, 0),
    `end_use_date`       datetime,
    `reserve_space_size` decimal(3, 0),
    `context`            varchar(20)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
