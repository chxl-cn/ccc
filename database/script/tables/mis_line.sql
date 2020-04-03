CREATE TABLE `mis_line`
(
    `id`                 varchar(128) NOT NULL,
    `line_code`          varchar(128) NOT NULL,
    `line_no`            double,
    `start_station_code` varchar(128),
    `end_station_code`   varchar(128),
    `start_km`           double,
    `end_km`             double,
    `line_type`          varchar(16),
    `gis_center_lon`     double,
    `gis_center_lat`     double,
    `is_show`            varchar(100),
    `direction`          varchar(20),
    `bureau_code`        varchar(128),
    `opt_person`         varchar(128),
    `opt_time`           datetime,
    `opt_action`         varchar(32),
    `opt_ip`             varchar(32),
    `opt_id`             varchar(128),
    `opt_context`        varchar(256),
    `is_modify_allowed`  varchar(8),
    `spd_dgr`            varchar(20),
    `ln_dgr`             varchar(20),
    `opn_dt`             datetime,
    `opt_mlg`            double,
    `pw_sply_md`         varchar(200),
    `ctnr_tp`            varchar(20),
    `prpt_dptmt`         varchar(100),
    `oth_desc`           varchar(200),
    PRIMARY KEY (`line_code`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
