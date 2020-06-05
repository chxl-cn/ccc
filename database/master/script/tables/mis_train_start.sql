CREATE TABLE mis_train_start
( id                 VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL ,
  train_number       VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL ,
  locomotive_code    VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL ,
  start_station_name VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin  ,
  end_station_name   VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin  ,
  end_arrival_time   DATETIME                                               ,
  position_code      VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin  ,
  position_name      VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin  ,
  drive_into_time    DATETIME                                               ,
  drive_out_time     DATETIME                                               ,
  direction          VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin  ,
  line_code          VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin  ,
  line_name          VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin  ,
  power_section_code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin  ,
  power_section_name VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin  ,
  bureau_code        VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin  ,
  bureau_name        VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin  ,
  start_leave_time   DATETIME                                               ,
  dttime             DATETIME                                               ,
  PRIMARY KEY ( id ) USING BTREE
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin
    ;