CREATE TABLE `duty_range`
(
    `id`                 varchar(128) NOT NULL,
    `org_code`           varchar(128) NOT NULL,
    `org_name`           varchar(128),
    `org_level`          double,
    `line_code`          varchar(40)  NOT NULL,
    `start_km`           decimal(12, 0),
    `end_km`             decimal(12, 0),
    `direction`          varchar(20)  NOT NULL,
    `bureau_code`        varchar(40),
    `bureau_name`        varchar(50),
    `workshop_code`      varchar(60),
    `workshop_name`      varchar(60),
    `power_section_code` varchar(60),
    `power_section_name` varchar(60),
    `distance`           double,
    `range`              varchar(100),
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
