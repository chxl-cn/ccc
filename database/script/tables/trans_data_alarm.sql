CREATE TABLE `trans_data_alarm`
(
    `id`                  varchar(40) NOT NULL,
    `locomotive_code`     tinytext    NOT NULL,
    `raised_time`         datetime    NOT NULL,
    `data_type`           varchar(8)  NOT NULL,
    `status`              varchar(10) NOT NULL,
    `severity`            varchar(10) NOT NULL,
    `is_typical`          tinyint(4),
    `use_depot`           tinytext,
    `p_org_code`          tinytext,
    `trans_time`          datetime,
    `trans_info`          text,
    `trans_result`        varchar(20),
    `is_re_syn`           varchar(8) DEFAULT (0),
    `is_trans_allowed`    tinyint(4) DEFAULT '0',
    `confidence_level`    tinyint(4),
    `failure_duration`    int(11),
    `retry_times`         int(11),
    `trans_loco_orgcode`  tinytext,
    `trans_power_orgcode` tinytext,
    `trans_view`          int(11),
    PRIMARY KEY (`id`),
    KEY `ix_trans_alarm_stat` (`trans_result`),
    KEY `ix_trans_alarm_rtm` (`raised_time`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
