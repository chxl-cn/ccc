CREATE TABLE data_gather_mileage_dev
( id                 VARCHAR(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL ,
  mileage_number     BIGINT(20)    ,
  status             VARCHAR(255)  ,
  alarm_number       INT(11)       ,
  raised_time        DATETIME      ,
  line_code          VARCHAR(255)  ,
  detect_device_code VARCHAR(255)  ,
  bureau_code        VARCHAR(255)  ,
  power_section_code VARCHAR(255)  ,
  PRIMARY KEY ( id )
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci
;