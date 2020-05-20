CREATE TABLE `alarm_aux_pold`
(
    `alarm_id`           VARCHAR(40)   DEFAULT NULL,
    `id`                 VARCHAR(40) NOT NULL,
    `bmi_file_name`      VARCHAR(256)  DEFAULT NULL,
    `rpt_file_name`      VARCHAR(256)  DEFAULT NULL,
    `alarm_rep_count`    INT(11)       DEFAULT NULL,
    `bow_offset`         DECIMAL(7, 2) DEFAULT NULL,
    `gps_body_direction` INT(11)       DEFAULT NULL,
    `img_body_direction` INT(11)       DEFAULT NULL,
    `reportwordstatus`   VARCHAR(5)    DEFAULT NULL,
    `reportwordurl`      VARCHAR(500)  DEFAULT NULL,
    `aflg_code`          VARCHAR(200)  DEFAULT NULL,
    `isexportreport`     VARCHAR(1)    DEFAULT NULL,
    `initial_code`       VARCHAR(40)   DEFAULT NULL,
    `accesscount`        INT(11)       DEFAULT NULL,
    `acflag_code`        VARCHAR(40)   DEFAULT NULL,
    `lock_person_name`   VARCHAR(100)  DEFAULT NULL,
    `lock_person_id`     VARCHAR(40)   DEFAULT NULL,
    `lock_time`          DATETIME      DEFAULT NULL,
    `is_trans_allowed`   INT(11)       DEFAULT NULL,
    `confidence_level`   INT(11)       DEFAULT NULL,
    `rerun_type`         INT(11)       DEFAULT NULL,
    `raised_time_aux`    DATETIME      DEFAULT NULL,
    `is_abnormal`        VARCHAR(10)   DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
    PARTITION BY RANGE COLUMNS (raised_time_aux)
        (
        PARTITION p_20180101 VALUES LESS THAN ("2018-01-02")

        );


