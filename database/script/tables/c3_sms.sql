CREATE TABLE `c3_sms`
(
    `id`                  VARCHAR(40) NOT NULL,
    `detect_time`         DATETIME    NOT NULL,
    `locomotive_code`     VARCHAR(30),
    `bow_status`          VARCHAR(8),
    `p_org_code`          VARCHAR(40),
    `train_no`            VARCHAR(30),
    `pole_code`           VARCHAR(50),
    `pole_no`             VARCHAR(30),
    `log_filename`        VARCHAR(80),
    `gps_course`          DECIMAL(10, 0),
    `gps_speed`           DECIMAL(10, 0),
    `km_mark`             INT(11),
    `record_time`         DATETIME,
    `line_no`             INT(11),
    `routing_no`          INT(11),
    `satellite_num`       INT(11),
    `speed`               INT(11),
    `recv_time`           DATETIME,
    `line_code`           VARCHAR(40),
    `direction`           VARCHAR(20),
    `position_code`       VARCHAR(40),
    `bureau_code`         VARCHAR(30),
    `power_section_code`  VARCHAR(40),
    `org_code`            VARCHAR(50),
    `eoas_direction`      VARCHAR(20),
    `eoas_km`             INT(11),
    `eoas_location`       INT(11),
    `eoas_time`           DATETIME,
    `pos_confirmed`       VARCHAR(1),
    `tax_monitor_status`  VARCHAR(8),
    `tax_position`        VARCHAR(10),
    `tax_schedule_status` VARCHAR(10),
    `version`             VARCHAR(8),
    `invalid_track`       VARCHAR(1),
    `trans_info`          VARCHAR(50),
    `driver_no`           VARCHAR(20),
    `file_location`       VARCHAR(1),
    `backup_file_dir`     VARCHAR(128),
    `relative_path`       VARCHAR(128),
    `log_file_path`       VARCHAR(128),
    KEY `id` (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
    PARTITION BY RANGE COLUMNS (detect_time)
        (PARTITION p_20180101 VALUES LESS THAN ('2018-01-02') ENGINE = InnoDB);