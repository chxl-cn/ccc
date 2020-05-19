DELIMITER ;
DROP EVENT IF EXISTS event_stat_sms;

DELIMITER  //
CREATE EVENT event_stat_sms
    ON SCHEDULE
        EVERY '15' MINUTE
    ON COMPLETION PRESERVE
    ENABLE
    COMMENT '每15分钟生成统计数据'
    DO
    BEGIN
        DECLARE v_CODE VARCHAR(5);
        DECLARE v_msg TEXT;
        DECLARE v_start DATETIME(6);
        DECLARE v_end DATETIME(6);
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            BEGIN
                GET DIAGNOSTICS CONDITION 1
                    v_CODE = RETURNED_SQLSTATE,
                    v_msg = MESSAGE_TEXT;
            END;

        SET v_start = now(6);
        CALL p_gen_stat_sms(NULL, NULL);
        SET v_end = now(6);
        INSERT INTO event_exec_log (event_name, start_time, end_time, stat_code, msg)
        VALUES ('stat_sms', v_start, v_end, v_CODE, v_msg);

    END //

