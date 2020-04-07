DELIMITER ;
DROP TRIGGER IF EXISTS trg_alarm_mod_hist_inc;

DELIMITER //
CREATE TRIGGER `trg_alarm_mod_hist_inc`
    AFTER UPDATE
    ON `alarm`
    FOR EACH ROW
trg_body:
BEGIN
    DECLARE v_loco VARCHAR(60);
    DECLARE v_rdt DATETIME;

    SET v_loco := OLD.detect_device_code;
    IF v_loco IS NULL THEN
        LEAVE trg_body;
    END IF;

    SET v_rdt := cast(old.raised_time AS DATE);

    REPLACE alarm_hist_inc
    SET running_date=v_rdt,
        locomotive_code=v_loco;
END //
