CREATE TABLE `mis_pole_aux`
(
    `pole_aux_id`      varchar(100) NOT NULL,
    `pole_code`        varchar(100),
    `pole_strct_type`  varchar(50),
    `pole_strct_value` varchar(100),
    PRIMARY KEY (`pole_aux_id`),
    KEY `ix_pole_aux_code` (`pole_code`),
    KEY `ix_pole_aux_strct` (`pole_strct_type`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
