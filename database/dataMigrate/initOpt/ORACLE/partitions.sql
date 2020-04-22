CREATE TABLE alarm_mg_part
    PARTITION BY RANGE(raised_time)
    INTERVAL(INTERVAL '1' DAY)
    (PARTITION VALUES LESS THAN (to_date('20010101','yyyymmdd')))
AS
SELECT *
FROM alarm;

CREATE TABLE alarm_aux_mg_part
    PARTITION BY RANGE(raised_time_aux)
    INTERVAL(INTERVAL '1' DAY)
    (PARTITION VALUES LESS THAN (to_date('20010101','yyyymmdd')))
AS
SELECT *
FROM alarm_aux
WHERE raised_time_aux IS NOT NULL
;


CREATE TABLE alarm_img_data_mg_part
    PARTITION BY RANGE(raise_time)
    INTERVAL(INTERVAL '1' DAY)
    (PARTITION VALUES LESS THAN (to_date('20010101','yyyymmdd')))
AS
SELECT *
FROM alarm_img_data
WHERE raise_time IS NOT NULL
;


CREATE TABLE c3_sms_mg_part
    PARTITION BY RANGE(detect_time )
    INTERVAL(INTERVAL '1' DAY)
    (PARTITION VALUES LESS THAN (to_date('20010101','yyyymmdd')))
AS
SELECT *
FROM c3_sms;
