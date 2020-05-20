CREATE TABLE `xt_funmenu_button`
(
    `id`           varchar(100) NOT NULL,
    `name`         varchar(100) ,
    `funmenucode`  varchar(100) ,
    `button_index` varchar(100) ,
    `button_group` varchar(100) ,
    `code`         varchar(100) ,
    `click`        varchar(100) ,
    `class`        varchar(100) ,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
