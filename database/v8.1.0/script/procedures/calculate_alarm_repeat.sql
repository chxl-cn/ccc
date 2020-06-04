DELIMITER ;
DROP PROCEDURE IF EXISTS calculate_alarm_repeat;

DELIMITER //

CREATE PROCEDURE calculate_alarm_repeat(IN p_canced_alarm_id       VARCHAR(60)
                                       , IN p_canced_main_alarm_id VARCHAR(60)
                                       , OUT result_               VARCHAR(60)
                                       )
BEGIN
    SET result_ = 'FALSE';

    IF main_alarmid IS NOT NULL THEN
        UPDATE
            alarm_aux x
            ,alarm a
        SET x.alarm_rep_count = alarm_rep_count - 1
        WHERE x.alarm_id = a.id
          AND a.svalue15 = main_alarmid;


        UPDATE
            alarm_aux
        SET alarm_rep_count = alarm_rep_count - 1
        WHERE alarm_id = main_alarmid;
    ELSE
        UPDATE
            alarm_aux
        SET alarm_rep_count = NULL
        WHERE alarm_id = alarmid;

        UPDATE
            alarm a
        SET a.svalue15 = NULL
        WHERE a.id = alarmid;


        UPDATE
            alarm_aux x
            ,alarm a
        SET a.alarm_rep_count = NULL
        WHERE a.svalue15 = alarmid
          AND x.alarm_id = a.id;


        UPDATE
            alarm
        SET svalue15 = NULL
        WHERE svalue15 = alarmid;
    END IF;

    SET result_ = 'TRUE';
    COMMIT;
END //

