DELIMITER ;
DROP TRIGGER IF EXISTS trg_c3_sms_ins_hist_inc;

DELIMITER //
CREATE TRIGGER `trg_c3_sms_ins_hist_inc`
    AFTER INSERT
    ON `c3_sms`
    FOR EACH ROW
trg_body:
BEGIN
    DECLARE v_loco VARCHAR(60);
    DECLARE v_rdt DATETIME;

    SET v_loco := new.locomotive_code;
    IF v_loco IS NULL THEN
        LEAVE trg_body ;
    END IF;

    SET v_rdt := cast(new.detect_time AS DATE);

    REPLACE c3_sms_hist_inc
    SET running_date=v_rdt,
        locomotive_code=v_loco;


END //