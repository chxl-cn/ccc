CREATE TABLE `locomotive`
(
    `id`                   varchar(35) NOT NULL,
    `locomotive_code`      varchar(16) NOT NULL,
    `p_org_code`           varchar(32),
    `org_code`             varchar(32),
    `bureau_code`          varchar(32),
    `data_recv_dept`       varchar(128),
    `status`               varchar(16),
    `model`                varchar(16),
    `vendor`               varchar(32),
    `create_date`          datetime,
    `fix_line_height`      decimal(4, 0),
    `fix_pulling_value`    decimal(3, 0),
    `is_fix_geo_para`      varchar(8),
    `install_date`         datetime,
    `device_version`       varchar(16),
    `flag`                 varchar(8),
    `is_modify_allowed`    varchar(8),
    `algorithm_version`    varchar(16),
    `device_bow_relations` varchar(512),
    `gd_x_direction`       decimal(22, 0),
    `is_abnormal`          varchar(10),
    PRIMARY KEY (`locomotive_code`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
