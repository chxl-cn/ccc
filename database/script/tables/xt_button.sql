CREATE TABLE `xt_button`
(
    `xt_button_id`     varchar(60),
    `xt_button_code`   varchar(60) NOT NULL,
    `xt_button_name`   varchar(100),
    `xt_mem_code`      varchar(60),
    `xt_button_obj_id` varchar(60),
    `xt_button_type`   varchar(60),
    `xt_req_method`    varchar(40),
    `xt_memo`          varchar(128),
    PRIMARY KEY (`xt_button_code`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
