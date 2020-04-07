DELIMITER ;
DROP TRIGGER IF EXISTS trg_c3_sms_mod_hist_inc;

DELIMITER //
CREATE TRIGGER `trg_c3_sms_mod_hist_inc`
    AFTER UPDATE
    ON `c3_sms`
    FOR EACH ROW
trg_body:
BEGIN
    DECLARE v_loco VARCHAR(60);
    DECLARE v_rdt DATETIME;

    SET v_loco := old.locomotive_code;

    IF v_loco IS NULL THEN
        LEAVE trg_body ;
    END IF;
    SET v_rdt := cast(old.detect_time AS DATE);

    REPLACE c3_sms_hist_inc
    SET running_date=v_rdt,
        locomotive_code=v_loco;
END //
