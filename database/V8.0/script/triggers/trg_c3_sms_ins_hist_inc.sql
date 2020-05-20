DELIMITER ;
DROP TRIGGER IF EXISTS trg_c3_sms_ins_hist_inc;

DELIMITER //
CREATE TRIGGER `trg_c3_sms_ins_hist_inc`
    AFTER INSERT
    ON `c3_sms`
    FOR EACH ROW
trg_body:
BEGIN

    IF new.locomotive_code IS NULL THEN
        LEAVE trg_body ;
    END IF;


    REPLACE c3_sms_hist_inc
    SET running_date=date(new.detect_time),
        locomotive_code=new.locomotive_code;


END //