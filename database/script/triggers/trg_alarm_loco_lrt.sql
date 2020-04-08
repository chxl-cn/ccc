DELIMITER ;
DROP TRIGGER IF EXISTS trg_alarm_loco_lrt;

DELIMITER //
CREATE TRIGGER `trg_alarm_loco_lrt`
    AFTER INSERT
    ON `alarm`
    FOR EACH ROW
trg_body:
BEGIN

    IF new.raised_time > now() OR new.detect_device_code IS NULL THEN
        LEAVE trg_body ;
    END IF;

    INSERT INTO loco_lrt(locomotive_code, data_sort)
    VALUES (new.detect_device_code, 1)
    ON DUPLICATE KEY
        UPDATE `last_time`   = if(last_time < new.`raised_time`, new.`raised_time`, last_time),
               `id`          = if(last_time < new.`raised_time`, new.`id`, `id`),
               `g_id`        = if(last_time < new.`raised_time`, if(ifnull(NEW.`valid_gps`, 0), new.`id`, `g_id`), `g_id`),
               `g_last_time` = if(last_time < new.`raised_time`, if(ifnull(NEW.`valid_gps`, 0), new.`raised_time`, `g_last_time`), `g_last_time`);


END //
