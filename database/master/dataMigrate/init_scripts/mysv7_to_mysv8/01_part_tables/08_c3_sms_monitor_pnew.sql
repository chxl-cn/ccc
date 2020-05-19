CREATE TABLE `c3_sms_monitor_pnew`
(
    `id`                 VARCHAR(40) NOT NULL,
    `detect_time`        DATETIME    NOT NULL,
    `device_group_no`    VARCHAR(20),
    `device_version`     VARCHAR(8),
    `temp_sensor_status` VARCHAR(4),
    `bow_updown_status`  VARCHAR(8),
    `parallel_span`      INT(11),
    `env_temp_1`         DECIMAL(10, 2),
    `env_temp_2`         DECIMAL(10, 2),
    `env_temp_3`         DECIMAL(10, 2),
    `env_temp_4`         DECIMAL(10, 2),
    `line_height_1`      INT(11),
    `line_height_2`      INT(11),
    `line_height_3`      INT(11),
    `line_height_4`      INT(11),
    `irv_temp_1`         DECIMAL(10, 2),
    `irv_temp_2`         DECIMAL(10, 2),
    `irv_temp_3`         DECIMAL(10, 2),
    `irv_temp_4`         DECIMAL(10, 2),
    `pulling_value_1`    INT(11),
    `pulling_value_2`    INT(11),
    `pulling_value_3`    INT(11),
    `pulling_value_4`    INT(11),
    `is_con_fz`          VARCHAR(4),
    `is_con_ir`          VARCHAR(4),
    `is_con_ov`          VARCHAR(4),
    `is_con_vi`          VARCHAR(4),
    `is_rec_fz`          VARCHAR(4),
    `is_rec_ir`          VARCHAR(4),
    `is_rec_ov`          VARCHAR(4),
    `is_rec_vi`          VARCHAR(4),
    `extra_info`         VARCHAR(400),
    KEY `id` (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
    PARTITION BY RANGE COLUMNS (detect_time)
        (PARTITION p_20180101 VALUES LESS THAN ('2018-01-02')
        );