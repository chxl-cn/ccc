CREATE TABLE `nos_bb`
(
    `ID`      varchar(128) NOT NULL,
    `CONTENT` text COMMENT '' json '',
    KEY `ID` (`ID`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  ROW_FORMAT = DYNAMIC;
