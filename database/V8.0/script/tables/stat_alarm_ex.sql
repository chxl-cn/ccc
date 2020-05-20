CREATE TABLE `stat_alarm_ex`
(
    `bureau_code`            varchar(40),
    `p_org_code`             varchar(100),
    `org_code`               varchar(60),
    `locomotive_code`        varchar(50) NOT NULL,
    `running_date`           datetime    NOT NULL,
    `direction`              varchar(100),
    `routing_no`             varchar(64),
    `line_code`              varchar(100),
    `faultalarmcntoflv1`     int,
    `faultalarmcntoflv2`     int,
    `faultalarmcntoflv3`     int,
    `faultalarmcntoflv1_out` int,
    `faultalarmcntoflv2_out` int,
    `faultalarmcntoflv3_out` int,
    `begin_time`             datetime,
    `end_time`               datetime,
    KEY `ix_stat_alarm_ex_locomotive_code` (`locomotive_code`),
    KEY `ix_stat_alarm_ex_org_code` (`org_code`),
    KEY `ix_stat_alarm_ex_line_code` (`line_code`),
    KEY `ix_stat_alarm_ex_running_date` (`running_date`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
    PARTITION BY RANGE COLUMNS (running_date)
        (PARTITION p_180101 VALUES LESS THAN ('2018-01-02') ENGINE = InnoDB)
