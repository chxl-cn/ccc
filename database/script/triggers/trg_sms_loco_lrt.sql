DELIMITER ;
DROP TRIGGER IF EXISTS trg_sms_loco_lrt;
DELIMITER //
CREATE TRIGGER `trg_sms_loco_lrt`
    AFTER INSERT
    ON `c3_sms`
    FOR EACH ROW
trg_body:
BEGIN
    DECLARE v_last_time DATETIME;
    DECLARE v_g_last_time DATETIME;
    DECLARE v_g_id VARCHAR(40);
    DECLARE v_id VARCHAR(40);

    IF new.detect_time > now() THEN
        LEAVE trg_body;
    END IF;

    SELECT min(id), min(g_id), min(last_time), min(g_last_time)
    INTO v_id, v_g_id, v_last_time, v_g_last_time
    FROM loco_lrt
    WHERE locomotive_code = new.locomotive_code
      AND data_sort = 2;


    SET sql_safe_updates = 0;

    IF v_id IS NOT NULL THEN
        UPDATE loco_lrt
        SET last_time  = new.detect_time,
            id         = new.id,
            g_id       = new.id,
            g_last_time=new.detect_time
        WHERE loco_lrt.last_time < new.detect_time
          AND locomotive_code = new.locomotive_code
          AND data_sort = 2;
    ELSE
        INSERT INTO loco_lrt(locomotive_code, data_sort, last_time, id, g_id, g_last_time)
        VALUES (new.locomotive_code,
                2,
                new.detect_time,
                new.id,
                new.id,
                new.detect_time);
    END IF;

END //