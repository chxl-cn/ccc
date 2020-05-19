CREATE TABLE `nos_aa`
(
    `ID`        varchar(128) NOT NULL,
    `INPUTDATE` datetime ,
    `CONTENT`   text  ,
    KEY `ID` (`ID`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
    PARTITION BY RANGE COLUMNS (INPUTDATE)
        (PARTITION p_20180101 VALUES LESS THAN ("2018-01-02") ENGINE = InnoDB);