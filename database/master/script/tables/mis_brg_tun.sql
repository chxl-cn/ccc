CREATE TABLE `mis_brg_tun`
(
    `id`                varchar(128) NOT NULL,
    `brg_tun_code`      varchar(128) NOT NULL,
    `brg_tun_type`      varchar(8),
    `position_code`     varchar(128),
    `direction`         varchar(20),
    `start_kmmark`      decimal(16, 0),
    `end_kmmark`        decimal(16, 0),
    `start_gis_lon`     double,
    `start_gis_lat`     double,
    `end_gis_lon`       double,
    `end_gis_lat`       double,
    `brg_tun_order`     double,
    `opt_person`        varchar(128),
    `opt_time`          datetime,
    `opt_action`        varchar(32),
    `opt_ip`            varchar(32),
    `opt_id`            varchar(128),
    `opt_context`       varchar(256),
    `is_modify_allowed` varchar(8),
    PRIMARY KEY (`brg_tun_code`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
