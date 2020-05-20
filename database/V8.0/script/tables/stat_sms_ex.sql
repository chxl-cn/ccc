CREATE TABLE `stat_sms_ex`
(
    `bureau_code`     varchar(40),
    `p_org_code`      varchar(32),
    `org_code`        varchar(60),
    `locomotive_code` varchar(16) NOT NULL,
    `running_date`    datetime    NOT NULL,
    `direction`       varchar(20),
    `routing_no`      varchar(16),
    `line_code`       varchar(16),
    `begin_time`      datetime,
    `end_time`        datetime,
    `begin_time_out`  datetime,
    `end_time_out`    datetime,
    KEY `ix_stat_sms_ex_locomotive_code` (`locomotive_code`),
    KEY `ix_stat_sms_ex_org_code` (`org_code`),
    KEY `ix_stat_sms_ex_line_code` (`line_code`),
    KEY `ix_stat_sms_ex_running_date` (`running_date`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
    PARTITION BY RANGE COLUMNS (running_date)
        (PARTITION p_180101 VALUES LESS THAN ("2018-01-02") ENGINE = InnoDB)
