CREATE TABLE `trans_hist`
(
    `id`                  varchar(40) NOT NULL,
    `locomotive_code`     tinytext,
    `data_type`           varchar(8),
    `trans_info`          tinytext,
    `trans_result`        tinytext,
    `trans_time`          datetime,
    `raised_time`         datetime,
    `use_depot`           tinytext,
    `is_re_syn`           varchar(8) DEFAULT (0),
    `is_trans_allowed`    tinyint(4),
    `confidence_level`    tinyint(4),
    `is_typical`          tinyint(4),
    `severity`            varchar(10),
    `status`              varchar(10),
    `p_org_code`          tinytext,
    `failure_duration`    int(11),
    `retry_times`         int(11),
    `trans_loco_orgcode`  tinytext,
    `trans_power_orgcode` tinytext,
    `trans_view`          int(11)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
