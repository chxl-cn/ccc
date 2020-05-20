CREATE TABLE `mis_sys_org_ext`
(
    `id`             varchar(40),
    `org_code`       varchar(128),
    `org_name`       varchar(128),
    `rcv_url`        varchar(256),
    `rcv_url_status` varchar(10)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
