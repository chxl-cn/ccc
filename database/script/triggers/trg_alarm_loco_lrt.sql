DELIMITER ;
DROP TRIGGER IF EXISTS trg_alarm_loco_lrt;

DELIMITER //
CREATE TRIGGER `trg_alarm_loco_lrt`
    AFTER INSERT
    ON `alarm`
    FOR EACH ROW
BEGIN
    DECLARE v_g_last_time DATETIME;
    DECLARE v_last_time DATETIME;
    DECLARE v_g_id VARCHAR(40);
    DECLARE v_id VARCHAR(40);

    IF new.raised_time <= now() THEN
        SELECT min(id), min(g_id), min(last_time), min(g_last_time)
        INTO v_id, v_g_id, v_last_time, v_g_last_time
        FROM loco_lrt
        WHERE locomotive_code = new.detect_device_code
          AND data_sort = 1;

        SET sql_safe_updates = 0;

        IF v_id IS NOT NULL THEN
            UPDATE loco_lrt
            SET last_time  = new.raised_time,
                id         = new.id,
                g_id       = new.id,
                g_last_time=new.raised_time
            WHERE loco_lrt.last_time < new.raised_time
              AND locomotive_code = new.detect_device_code
              AND data_sort = 1;
        ELSE
            INSERT INTO loco_lrt(locomotive_code, data_sort, last_time, id, g_id, g_last_time)
            VALUES (new.detect_device_code, 1, new.raised_time, new.id, new.id, new.raised_time);
        END IF;
    END IF;
END //
