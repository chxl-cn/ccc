CREATE TABLE `tsys_org`
(
    `id`                varchar(128) NOT NULL,
    `org_code`          varchar(128) NOT NULL,
    `sup_org_code`      varchar(128),
    `org_layer`         double,
    `org_degree`        varchar(32),
    `org_type`          varchar(32),
    `org_addr`          varchar(256),
    `org_status`        varchar(32),
    `org_order`         double,
    `link_man`          varchar(256),
    `link_tel`          varchar(256),
    `postcode`          varchar(16),
    `gis_lat`           double,
    `gis_lon`           double,
    `remark`            varchar(256),
    `is_leaf`           varchar(8),
    `org_area`          varchar(128),
    `is_grouped`        varchar(8),
    `is_modify_allowed` varchar(8),
    PRIMARY KEY (`org_code`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
