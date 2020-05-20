CREATE TABLE `c3_sms_hist_inc`
(
    `running_date`    DATETIME    NOT NULL,
    `locomotive_code` VARCHAR(16) NOT NULL,
    PRIMARY KEY (`running_date`, `locomotive_code`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;