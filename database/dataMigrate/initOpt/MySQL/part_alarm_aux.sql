CREATE TABLE `alarm_aux_mg_part`
(
    `alarm_id`           VARCHAR(40),
    `id`                 VARCHAR(40) NOT NULL,
    `bmi_file_name`      VARCHAR(256),
    `rpt_file_name`      VARCHAR(256),
    `alarm_rep_count`    INT(11),
    `bow_offset`         DECIMAL(7, 2),
    `gps_body_direction` INT(11),
    `img_body_direction` INT(11),
    `reportwordstatus`   VARCHAR(5),
    `reportwordurl`      TEXT,
    `aflg_code`          VARCHAR(200),
    `aflg_name`          VARCHAR(200),
    `isexportreport`     VARCHAR(1),
    `initial_code`       VARCHAR(40),
    `initial_code_name`  VARCHAR(60),
    `accesscount`        INT(11),
    `acflag_code`        VARCHAR(40),
    `acflag_name`        VARCHAR(60),
    `lock_person_name`   TINYTEXT,
    `lock_person_id`     VARCHAR(40),
    `lock_time`          DATETIME,
    `is_trans_allowed`   INT(11),
    `confidence_level`   INT(11),
    `map_add_ima`        TINYTEXT,
    `vi_add_ima`         TINYTEXT,
    `oa_add_ima`         TINYTEXT,
    `sample_code`        VARCHAR(40),
    `sample_name`        VARCHAR(60),
    `sample_detail_code` VARCHAR(100),
    `sample_detail_name` VARCHAR(100),
    `rerun_type`         INT(11),
    `raised_time_aux`    DATETIME,
    `algcode`            VARCHAR(50),
    `scencesample_code`  TINYTEXT,
    `scencesample_name`  TINYTEXT,
    `is_abnormal`        VARCHAR(10),
    `algcodename`        VARCHAR(50)
)
    PARTITION BY RANGE COLUMNS (raised_time_aux)
        (
        PARTITION p_20180101 VALUES LESS THAN ("2018-01-02")
        );