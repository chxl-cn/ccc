CREATE TABLE `datapermisson`
(
    `id`        VARCHAR(100) NOT NULL,
    `masterid`  VARCHAR(100) NOT NULL,
    `role_type` VARCHAR(10),
    `org_code`  VARCHAR(200),
    `org_name`  VARCHAR(300)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
;