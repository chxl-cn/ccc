CREATE TABLE `xt_funmenu`
(
    `id`         varchar(128) NOT NULL,
    `code`       varchar(30)  NOT NULL,
    `name`       varchar(100),
    `subcode`    varchar(30),
    `parentcode` varchar(30),
    `img`        varchar(100),
    `url`        varchar(200),
    `flag`       varchar(10),
    `note`       varchar(200),
    `sort`       double,
    `seq`        varchar(255),
    `layer`      double,
    `fname`      varchar(2000),
    `subcount`   double,
    `leaf`       varchar(10),
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
