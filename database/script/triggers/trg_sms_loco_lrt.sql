DELIMITER ;
DROP TRIGGER IF EXISTS trg_sms_loco_lrt;
DELIMITER //
CREATE TRIGGER `trg_sms_loco_lrt`
    AFTER INSERT
    ON `c3_sms`
    FOR EACH ROW
trg_body:
BEGIN

    IF new.detect_time > now() THEN
        LEAVE trg_body;
    END IF;

    INSERT INTO loco_lrt(locomotive_code, data_sort)
    VALUES (new.locomotive_code, 2)
    ON DUPLICATE KEY
        UPDATE `last_time`   = if(`last_time` < new.`detect_time`, new.`detect_time`, `last_time`),
               `id`          = if(`last_time` < new.`detect_time`, new.`id`, `id`),
               `g_id`        = if(`last_time` < new.`detect_time`, if(ifnull(NEW.`valid_gps`, 0), new.`id`, `g_id`), `g_id`),
               `g_last_time` = if(`last_time` < new.`detect_time`, if(ifnull(NEW.`valid_gps`, 0), new.`detect_time`, `g_last_time`), `g_last_time`);

END //