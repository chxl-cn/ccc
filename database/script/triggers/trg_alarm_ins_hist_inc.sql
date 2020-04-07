DELIMITER ;
DROP TRIGGER IF EXISTS trg_alarm_ins_hist_inc;

DELIMITER //
CREATE TRIGGER `trg_alarm_ins_hist_inc`
    AFTER INSERT
    ON `alarm`
    FOR EACH ROW
BEGIN
    DECLARE v_loco VARCHAR(60);
    DECLARE v_rdt DATETIME;

    SET v_loco := new.detect_device_code;
    SET v_rdt := cast(new.raised_time AS DATE);

    IF v_loco IS NOT NULL THEN
        REPLACE alarm_hist_inc SET running_date=v_rdt, locomotive_code=v_loco ;
    END IF;


END //