CREATE TABLE `alarm_hist_inc`
(
    `running_date`    DATETIME    NOT NULL,
    `locomotive_code` VARCHAR(16) NOT NULL,
    PRIMARY KEY (`locomotive_code`, `running_date`),
    KEY `ix_alarm_hist_inc_date` (`running_date`),
    KEY `ix_alarm_hist_inc_loco` (`locomotive_code`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
;