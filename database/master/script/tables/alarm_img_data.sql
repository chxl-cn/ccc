CREATE TABLE alarm_img_data
( alarm_id      VARCHAR(40) NOT NULL ,
  spark_elapse  INT(11) ,
  isblackcenter INT(11) ,
  raise_time    DATETIME ,
  dev_type_ana  VARCHAR(40)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci
;