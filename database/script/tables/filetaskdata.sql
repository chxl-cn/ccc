CREATE TABLE `filetaskdata`
(
    `id`                 varchar(50) NOT NULL,
    `queue_id`           varchar(50),
    `timestamp_irv`      decimal(20, 0),
    `gis_x`              double,
    `gis_y`              double,
    `gis_x_o`            double,
    `gis_y_o`            double,
    `n_satellite`        decimal(5, 0),
    `n_stagger`          decimal(10, 0),
    `n_high`             decimal(10, 0),
    `n_irv_temp`         decimal(10, 0),
    `n_env_temp`         decimal(10, 0),
    `n_speed`            decimal(10, 0),
    `line_code`          varchar(50),
    `direction`          varchar(50),
    `position_code`      varchar(50),
    `brg_tun_code`       varchar(50),
    `km_mark`            decimal(10, 0),
    `pole_number`        varchar(20),
    `pole_code`          varchar(50),
    `pole_serialno`      decimal(10, 0),
    `bureau_code`        varchar(50),
    `power_section_code` varchar(50),
    `p_org_code`         varchar(50),
    `org_code`           varchar(50),
    `status`             varchar(50),
    `createtime`         datetime,
    `edittime`           datetime,
    `tasktime`           datetime,
    `bow_offset`         double,
    `locomotive_code`    varchar(100),
    `irv_idx`            double,
    `vi_idx`             double,
    `ov_idx`             double,
    `aux_idx`            double,
    PRIMARY KEY (`id`),
    KEY `ix_filetaskdata_irv` (`timestamp_irv`),
    KEY `ix_filetaskdata_loc` (`locomotive_code`),
    KEY `ix_filetaskdata_QUEUE_ID` (`queue_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
