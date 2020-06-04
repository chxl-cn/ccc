CREATE TABLE `mis_subst_exp`
(
    `id`         VARCHAR(40) NOT NULL,
    `rec_no`     DECIMAL(10, 0),
    `subst_code` VARCHAR(40),
    `subst_name` VARCHAR(40),
    `trbl_time`  DATETIME,
    `spw_tp`     VARCHAR(40),
    `dev_name`   VARCHAR(40),
    `trbl_sn`    DECIMAL(10, 0),
    `trbl_cnt`   VARCHAR(400),
    `ld_usr`     VARCHAR(40),
    `ld_time`    DATETIME,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
;