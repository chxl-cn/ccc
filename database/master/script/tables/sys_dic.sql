CREATE TABLE `sys_dic`
(
    `id`                varchar(100) NOT NULL,
    `dic_code`          varchar(100) NOT NULL,
    `code_type`         varchar(100),
    `description`       varchar(512),
    `p_code`            varchar(100),
    `category`          varchar(100),
    `is_modify_allowed` varchar(8),
    `show_priority`     double,
    `report_priority`   decimal(4, 0),
    PRIMARY KEY (`dic_code`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
