CREATE TABLE `trans_data_ext`
(
    `id`                  varchar(40) NOT NULL,
    `trans_power_orgcode` varchar(40),
    `trans_loco_orgcode`  varchar(200),
    `trans_view`          int(11),
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
