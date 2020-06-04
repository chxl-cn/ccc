CREATE TABLE `alarm_img_data_pold`
(
    `alarm_id`      VARCHAR(40) NOT NULL,
    `spark_elapse`  INT(11)     DEFAULT NULL,
    `isblackcenter` INT(11)     DEFAULT NULL,
    `raise_time`    DATETIME    DEFAULT NULL,
    `dev_type_ana`  VARCHAR(40) DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
    PARTITION BY RANGE COLUMNS (raise_time)
        (
        PARTITION p_20180101 VALUES LESS THAN ("2018-01-02")
        );