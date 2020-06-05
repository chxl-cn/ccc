CREATE TABLE alarm_hist
( pid                 VARCHAR(50) NOT NULL ,
  alarm_id            VARCHAR(50)      ,
  category_code       VARCHAR(10)      ,
  detect_device_code  VARCHAR(50)      ,
  raised_time         DATETIME         ,
  direction           TINYTEXT ,
  km_mark             INT(11)          ,
  line_code           TINYTEXT ,
  pole_number         VARCHAR(10)      ,
  brg_tun_code        TINYTEXT ,
  position_code       TINYTEXT ,
  station_no          VARCHAR(20)      ,
  station_name        VARCHAR(50)      ,
  area_no             VARCHAR(20)      ,
  routing_no          VARCHAR(64)      ,
  severity            VARCHAR(10)      ,
  code                VARCHAR(20)      ,
  status              VARCHAR(20)      ,
  alarm_analysis      TEXT ,
  source              VARCHAR(50)      ,
  data_type           VARCHAR(20)      ,
  remark              TEXT ,
  status_time         DATETIME         ,
  created_time        DATETIME         ,
  harddisk_manage_id  TINYTEXT ,
  task_id             TINYTEXT ,
  report_person       TINYTEXT ,
  report_date         DATETIME         ,
  p_org_code          TINYTEXT ,
  org_code            TINYTEXT ,
  workshop_code       TINYTEXT ,
  power_section_code  TINYTEXT ,
  bureau_code         VARCHAR(40)      ,
  substation_code     TINYTEXT ,
  power_device_code   TINYTEXT ,
  power_device_type   TINYTEXT ,
  profession_type     TINYTEXT ,
  comp_code           TINYTEXT ,
  comp_type           TINYTEXT ,
  repair_date         DATETIME         ,
  repair_org          TINYTEXT ,
  repair_person       TINYTEXT ,
  repair_method       TEXT ,
  process_type        TINYTEXT ,
  repaired_pic        TEXT ,
  repaired_status     TINYTEXT ,
  check_person        TINYTEXT ,
  vendor              VARCHAR(50)      ,
  svalue6             TEXT ,
  svalue7             TEXT ,
  svalue8             TEXT ,
  svalue10            TEXT ,
  svalue12            TEXT ,
  svalue13            TEXT ,
  svalue15            TEXT ,
  nvalue1             INT(11)          ,
  nvalue2             INT(11)          ,
  nvalue3             INT(11)          ,
  nvalue4             INT(11)          ,
  nvalue5             INT(11)          ,
  nvalue6             INT(11)          ,
  nvalue7             INT(11)          ,
  nvalue8             INT(11)          ,
  nvalue9             INT(11)          ,
  nvalue11            INT(11)          ,
  nvalue12            INT(11)          ,
  nvalue13            INT(11)          ,
  nvalue14            INT(11)          ,
  nvalue15            INT(11)          ,
  nvalue16            INT(11)          ,
  nvalue17            INT(11)          ,
  nvalue18            INT(11)          ,
  nvalue19            INT(11)          ,
  nvalue20            INT(11)          ,
  dvalue1             DATETIME         ,
  dvalue2             DATETIME         ,
  dvalue3             DATETIME         ,
  dvalue4             DATETIME         ,
  dvalue5             DATETIME         ,
  trans_info          TEXT ,
  review_person       VARCHAR(20)      ,
  review_info         TINYTEXT ,
  review_time         DATETIME         ,
  is_typical          VARCHAR(10)      ,
  is_customer_ana     VARCHAR(10)      ,
  tax_monitor_status  VARCHAR(10)      ,
  pos_confirmed       VARCHAR(1)       ,
  cust_alarm_code     VARCHAR(40)      ,
  edit_person         VARCHAR(40)      ,
  edit_time           DATETIME         ,
  tax_schedule_status VARCHAR(16)      ,
  tax_position        VARCHAR(16)      ,
  raised_time_m       DECIMAL(20 , 0)  ,
  eoas_train_speed    INT(11)          ,
  eoas_time           DATETIME         ,
  report_deptname     TINYTEXT ,
  dev_name            TINYTEXT ,
  process_deptname    TINYTEXT ,
  process_date        DATETIME         ,
  process_person      TINYTEXT ,
  process_status      TINYTEXT ,
  process_details     TINYTEXT ,
  attachment          TINYTEXT ,
  report_overdue      VARCHAR(10)      ,
  process_overdue     VARCHAR(10)      ,
  check_details       TEXT ,
  alarm_reason        TEXT ,
  eoas_location       INT(11)          ,
  plan_id             TINYTEXT ,
  plan_task_id        TINYTEXT ,
  eoas_km             INT(11)          ,
  eoas_direction      TINYTEXT ,
  airesult            TEXT
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci
    /*!50500 PARTITION BY RANGE COLUMNS (raised_time)
    (PARTITION p_20180101 VALUES LESS THAN ('2018-01-02') ENGINE = InnoDB) */
;