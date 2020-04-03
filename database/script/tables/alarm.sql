CREATE TABLE `alarm`
(
    `id`                  VARCHAR(40) NOT NULL,
    `vendor`              TINYTEXT,
    `category_code`       VARCHAR(10),
    `detect_device_code`  TINYTEXT,
    `data_type`           TINYTEXT,
    `dvalue1`             DATETIME,
    `dvalue2`             DATETIME,
    `dvalue3`             DATETIME,
    `dvalue4`             DATETIME,
    `dvalue5`             DATETIME,
    `nvalue1`             INT(11),
    `nvalue2`             INT(11),
    `nvalue3`             INT(11),
    `nvalue4`             INT(11),
    `nvalue5`             INT(11),
    `nvalue6`             INT(11),
    `nvalue8`             INT(11),
    `nvalue13`            INT(11),
    `nvalue14`            INT(11),
    `nvalue15`            INT(11),
    `nvalue16`            INT(11),
    `created_time`        DATETIME,
    `raised_time`         DATETIME    NOT NULL,
    `report_date`         DATETIME,
    `status_time`         DATETIME,
    `report_person`       TINYTEXT,
    `is_typical`          VARCHAR(1) DEFAULT '0',
    `severity`            TINYTEXT,
    `status`              TINYTEXT,
    `code`                TINYTEXT,
    `cust_alarm_code`     TINYTEXT,
    `p_org_code`          TINYTEXT,
    `svalue8`             TEXT,
    `svalue14`            TEXT,
    `svalue15`            TEXT,
    `km_mark`             INT(11),
    `pole_number`         TINYTEXT,
    `brg_tun_code`        TINYTEXT,
    `position_code`       TINYTEXT,
    `direction`           TINYTEXT,
    `line_code`           VARCHAR(40),
    `org_code`            TINYTEXT,
    `workshop_code`       TINYTEXT,
    `power_section_code`  TINYTEXT,
    `bureau_code`         TINYTEXT,
    `alarm_analysis`      TEXT,
    `task_id`             VARCHAR(40),
    `tax_monitor_status`  VARCHAR(1),
    `routing_no`          TINYINT(4),
    `area_no`             TINYTEXT,
    `station_no`          TINYTEXT,
    `source`              TINYTEXT,
    `eoas_direction`      TINYTEXT,
    `eoas_km`             INT(11),
    `eoas_location`       TINYINT(4),
    `eoas_time`           DATETIME,
    `eoas_train_speed`    INT(11),
    `raised_time_m`       BIGINT(20),
    `tax_position`        TINYTEXT,
    `tax_schedule_status` TINYTEXT,
    `pos_confirmed`       VARCHAR(1),
    `is_customer_ana`     VARCHAR(1),
    `org_file_location`   VARCHAR(1),
    `pic_file_location`   VARCHAR(1),
    `summary`             TINYTEXT,
    `repair_date`         DATETIME,
    `isdayreport`         VARCHAR(1),
    `isexportreport`      VARCHAR(1),
    `lock_person_id`      VARCHAR(40),
    `is_trans_allowed`    TINYINT(4) DEFAULT '0',
    `acflag_code`         TINYTEXT,
    `sample_code`         TINYTEXT,
    `scencesample_code`   TINYTEXT,
    `accesscount`         INT(11)    DEFAULT '0',
    `initial_code`        TINYTEXT,
    `aflg_code`           TINYTEXT,
    `algcode`             TINYTEXT,
    `reportwordstatus`    VARCHAR(5),
    `rerun_type`          INT(11),
    `spark_elapse`        INT(11),
    `isblackcenter`       TINYINT(4),
    `dev_type_ana`        TINYTEXT,
    `spart_pixel_pct`     DECIMAL(5, 2),
    `spart_pixels`        INT(11),
    `gray_avg_left`       SMALLINT(4),
    `gray_avg_right`      SMALLINT(4),
    `gray_avg_bow_rect`   SMALLINT(4),
    `spark_shape`         INT(11),
    `spark_num`           TINYINT(4),
    `device_id`           TINYTEXT,
    `eoas_trainno`        TINYTEXT,
    `alarm_rep_count`     INT(11),
    `sample_detail_code`  VARCHAR(40),
    KEY `id` (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
    PARTITION BY RANGE COLUMNS (raised_time)
        (PARTITION p_20180101 VALUES LESS THAN ('2018-01-02') ENGINE = InnoDB);