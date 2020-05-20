DELIMITER  ;

ALTER TABLE getfiletask
    ADD `alarm_raised_time` DATETIME;

UPDATE getfiletask k,alarm a
SET k.alarm_raised_time = a.raised_time
WHERE k.alarm_id = a.id
  AND k.alarm_id IS NOT NULL;


