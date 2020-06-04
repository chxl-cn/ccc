CREATE TABLE `button_authority`
(
    `but_auth_id`          VARCHAR(60) NOT NULL,
    `but_auth_fun_code`    VARCHAR(60)  DEFAULT NULL,
    `but_auth_type`        VARCHAR(60)  DEFAULT NULL,
    `but_auth_type_vcode`  VARCHAR(60)  DEFAULT NULL,
    `but_auth_but_code`    VARCHAR(60)  DEFAULT NULL,
    `but_auth_but_visible` VARCHAR(6)   DEFAULT NULL,
    `but_auth_memo`        VARCHAR(128) DEFAULT NULL,
    `xt_button_obj_id`     VARCHAR(60)  DEFAULT NULL,
    `xt_button_type`       VARCHAR(60)  DEFAULT NULL,
    PRIMARY KEY (`but_auth_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
;