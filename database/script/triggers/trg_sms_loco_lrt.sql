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



END //