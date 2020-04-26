/*
    本脚本作用是分区相关业务表，以方便快速进行数据迁移，但需指定如下条件：
    1、提前时间点：xxxxxxx
    2、日期格式为 yyyymmdd (年月日)

 */


CREATE TABLE alarm_mg_part
    PARTITION BY RANGE (raised_time)
    INTERVAL (INTERVAL '1' DAY)
(
    PARTITION VALUES LESS THAN (to_date('20010101', 'yyyymmdd'))
)
AS
SELECT *
FROM alarm
where raised_time < to_date('xxxxxxxx', 'yyyymmdd')
;

CREATE TABLE alarm_aux_mg_part
    PARTITION BY RANGE (raised_time_aux)
    INTERVAL (INTERVAL '1' DAY)
(
    PARTITION VALUES LESS THAN (to_date('20010101', 'yyyymmdd'))
)
AS
SELECT *
FROM alarm_aux
WHERE raised_time_aux < to_date('xxxxxxxx', 'yyyymmdd')
;


CREATE TABLE alarm_img_data_mg_part
    PARTITION BY RANGE (raise_time)
    INTERVAL (INTERVAL '1' DAY)
(
    PARTITION VALUES LESS THAN (to_date('20010101', 'yyyymmdd'))
)
AS
SELECT *
FROM alarm_img_data
WHERE raise_time < to_date('xxxxxxxx', 'yyyymmdd')
;


CREATE TABLE c3_sms_mg_part
    PARTITION BY RANGE (detect_time)
    INTERVAL (INTERVAL '1' DAY)
(
    PARTITION VALUES LESS THAN (to_date('20010101', 'yyyymmdd'))
)
AS
SELECT *
FROM c3_sms
WHERE detect_time < to_date('xxxxxxxx', 'yyyymmdd');
