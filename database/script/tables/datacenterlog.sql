CREATE TABLE `datacenterlog`
(
    `id`             VARCHAR(100) NOT NULL,
    `user_name`      VARCHAR(100) DEFAULT NULL,
    `module_name`    VARCHAR(100) DEFAULT NULL,
    `client_ip`      VARCHAR(100) DEFAULT NULL,
    `detail`         TEXT,
    `log_time`       DATETIME     DEFAULT NULL,
    `operation_name` VARCHAR(100) DEFAULT NULL,
    `log_level`      INT(11)      DEFAULT NULL,
    `server_ip`      VARCHAR(100) DEFAULT NULL,
    `fail_reason`    TEXT,
    `is_succeed`     VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `ix_datacenterlog_user_name` (`user_name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
;