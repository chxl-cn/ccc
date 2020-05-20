CREATE TABLE `mis_mod_sql`
(
    `mod_name` varchar(40) NOT NULL,
    `sql_no`   tinyint(4)  NOT NULL,
    `sql_text` text,
    PRIMARY KEY (`mod_name`, `sql_no`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
