CREATE TABLE `sample_afcode_relation`
(
    `id`          varchar(50) NOT NULL,
    `sample_code` varchar(50),
    `alarm_code`  varchar(200),
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
