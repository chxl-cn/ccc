CREATE TABLE `trans_data`
(
    `id`               varchar(128) NOT NULL,
    `locomotive_code`  varchar(128),
    `data_type`        varchar(8),
    `trans_info`       text,
    `trans_result`     varchar(32),
    `trans_time`       datetime,
    `raised_time`      datetime,
    `use_depot`        varchar(32),
    `is_re_syn`        varchar(8),
    `is_trans_allowed` int(11),
    `confidence_level` int(11),
    PRIMARY KEY (`id`),
    KEY `ix_trans_dt` (`raised_time`),
    KEY `ix_trans_trans_rt` (`trans_result`),
    KEY `ix_is_trans_allowed` (`is_trans_allowed`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
