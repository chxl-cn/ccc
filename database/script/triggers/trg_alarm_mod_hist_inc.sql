DELIMITER ;
DROP TRIGGER IF EXISTS trg_alarm_mod_hist_inc;

DELIMITER //
CREATE TRIGGER `trg_alarm_mod_hist_inc`
    AFTER UPDATE
    ON `alarm`
    FOR EACH ROW
trg_body:
BEGIN

    IF new.detect_device_code IS NULL THEN
        LEAVE trg_body;
    END IF;


    REPLACE alarm_hist_inc
    SET running_date=date(new.raised_time),
        locomotive_code=new.detect_device_code;
END //
