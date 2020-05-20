
CREATE TABLE `data_gather_mileage`
(
    `id`                 VARCHAR(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `mileage_number`     BIGINT(20)   DEFAULT NULL,
    `status`             VARCHAR(255) DEFAULT NULL,
    `alarm_number`       INT(11)      DEFAULT NULL,
    `raised_time`        DATETIME     DEFAULT NULL,
    `line_code`          VARCHAR(255) DEFAULT NULL,
    `detect_device_code` VARCHAR(255) DEFAULT NULL,
    `bureau_code`        VARCHAR(255) DEFAULT NULL,
    `power_section_code` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
;