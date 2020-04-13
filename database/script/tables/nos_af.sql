CREATE TABLE `nos_af`
(
    `ID`        varchar(128) NOT NULL,
    `INPUTDATE` datetime COMMENT '' date '',
    `CONTENT`   text 
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  ROW_FORMAT = DYNAMIC;
