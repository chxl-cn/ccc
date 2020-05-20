CREATE TABLE `mis_sys_fault_extern`
(
    `extern_key`    varchar(200) NOT NULL,
    `extern_code`   varchar(200),
    `extern_name`   varchar(200),
    `extern_ftp`    text,
    `category_code` varchar(100),
    `pic`           varchar(100),
    `ftp_user`      varchar(100),
    `ftp_password`  varchar(100),
    `start_time`    datetime,
    `duration`      int(11),
    PRIMARY KEY (`extern_key`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
