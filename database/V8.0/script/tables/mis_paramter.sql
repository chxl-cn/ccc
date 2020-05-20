CREATE TABLE `mis_paramter`
(
    `id`      varchar(128) NOT NULL,
    `key`     varchar(200),
    `titile`  varchar(200),
    `context` varchar(200),
    `time`    datetime,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
