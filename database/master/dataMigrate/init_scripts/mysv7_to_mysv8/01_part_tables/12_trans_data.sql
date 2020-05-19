DELIMITER ;
CREATE TABLE `trans_data_alarm`
(
    `id`                  VARCHAR(40) NOT NULL,
    `locomotive_code`     TINYTEXT    NOT NULL,
    `raised_time`         DATETIME    NOT NULL,
    `data_type`           VARCHAR(8)  NOT NULL,
    `status`              VARCHAR(10) NOT NULL,
    `severity`            VARCHAR(10) NOT NULL,
    `is_typical`          TINYINT(4),
    `use_depot`           TINYTEXT,
    `p_org_code`          TINYTEXT,
    `trans_time`          DATETIME,
    `trans_info`          TEXT,
    `trans_result`        VARCHAR(20),
    `is_re_syn`           VARCHAR(8) DEFAULT (0),
    `is_trans_allowed`    TINYINT(4) DEFAULT '0',
    `confidence_level`    TINYINT(4),
    `failure_duration`    INT(11),
    `retry_times`         INT(11),
    `trans_loco_orgcode`  TINYTEXT,
    `trans_power_orgcode` TINYTEXT,
    `trans_view`          INT(11),
    PRIMARY KEY (`id`),
    KEY `ix_trans_alarm_stat` (`trans_result`),
    KEY `ix_trans_alarm_rtm` (`raised_time`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `trans_data_log`
(
    `id`                  VARCHAR(40) NOT NULL,
    `locomotive_code`     TINYTEXT,
    `raised_time`         DATETIME,
    `data_type`           VARCHAR(8),
    `p_org_code`          TINYTEXT,
    `trans_info`          TEXT,
    `trans_result`        VARCHAR(20),
    `trans_time`          DATETIME,
    `use_depot`           TINYTEXT,
    `is_re_syn`           VARCHAR(8)           DEFAULT (0),
    `is_trans_allowed`    TINYINT(4)  NOT NULL DEFAULT '0',
    `confidence_level`    TINYINT(4),
    `retry_times`         INT(11),
    `failure_duration`    INT(11),
    `trans_loco_orgcode`  TINYTEXT,
    `trans_power_orgcode` TINYTEXT,
    `trans_view`          INT(11),
    PRIMARY KEY (`id`),
    KEY `ix_trans_log_stat` (`trans_result`),
    KEY `ix_trans_log_rtm` (`raised_time`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `trans_data_log`
(
    `id`                  VARCHAR(40) NOT NULL,
    `locomotive_code`     TINYTEXT,
    `raised_time`         DATETIME,
    `data_type`           VARCHAR(8),
    `p_org_code`          TINYTEXT,
    `trans_info`          TEXT,
    `trans_result`        VARCHAR(20),
    `trans_time`          DATETIME,
    `use_depot`           TINYTEXT,
    `is_re_syn`           VARCHAR(8)           DEFAULT (0),
    `is_trans_allowed`    TINYINT(4)  NOT NULL DEFAULT '0',
    `confidence_level`    TINYINT(4),
    `retry_times`         INT(11),
    `failure_duration`    INT(11),
    `trans_loco_orgcode`  TINYTEXT,
    `trans_power_orgcode` TINYTEXT,
    `trans_view`          INT(11),
    PRIMARY KEY (`id`),
    KEY `ix_trans_log_stat` (`trans_result`),
    KEY `ix_trans_log_rtm` (`raised_time`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
