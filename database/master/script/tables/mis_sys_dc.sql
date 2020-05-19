CREATE TABLE `mis_sys_dc`
(
    `id`      varchar(40)  NOT NULL,
    `dc_code` varchar(128),
    `dc_name` varchar(128),
    `url`     varchar(256) NOT NULL,
    `status`  int(11),
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
