CREATE TABLE `datacenterlog`
(
    `id`             VARCHAR(100) NOT NULL,
    `user_name`      VARCHAR(100),
    `module_name`    VARCHAR(100),
    `client_ip`      VARCHAR(100),
    `detail`         TEXT,
    `log_time`       DATETIME,
    `operation_name` VARCHAR(100),
    `log_level`      INT(11),
    `server_ip`      VARCHAR(100),
    `fail_reason`    TEXT,
    `is_succeed`     VARCHAR(100),
    PRIMARY KEY (`id`),
    KEY `ix_datacenterlog_user_name` (`user_name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
;