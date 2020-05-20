CREATE TABLE `mis_sys_dc_org_map`
(
    `id`       varchar(40) NOT NULL,
    `org_code` varchar(128),
    `org_name` varchar(128),
    `dc_code`  varchar(128),
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
