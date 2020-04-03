CREATE TABLE `trans_data_log`
(
    `id`                  varchar(40) NOT NULL,
    `locomotive_code`     tinytext,
    `raised_time`         datetime,
    `data_type`           varchar(8),
    `p_org_code`          tinytext,
    `trans_info`          text,
    `trans_result`        varchar(20),
    `trans_time`          datetime,
    `use_depot`           tinytext,
    `is_re_syn`           varchar(8)           DEFAULT (0),
    `is_trans_allowed`    tinyint(4)  NOT NULL DEFAULT '' 0 '',
    `confidence_level`    tinyint(4),
    `retry_times`         int(11),
    `failure_duration`    int(11),
    `trans_loco_orgcode`  tinytext,
    `trans_power_orgcode` tinytext,
    `trans_view`          int(11),
    PRIMARY KEY (`id`),
    KEY `ix_trans_log_stat` (`trans_result`),
    KEY `ix_trans_log_rtm` (`raised_time`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
