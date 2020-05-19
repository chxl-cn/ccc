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

    CALL p_loco_lrt_ins(new.detect_device_code, 1, new.id, new.raised_time, new.valid_gps);
END //
