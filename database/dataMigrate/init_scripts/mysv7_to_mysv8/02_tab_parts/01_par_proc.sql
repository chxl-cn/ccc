DELIMITER ;
DROP PROCEDURE IF EXISTS p_gen_tab_parts;

DELIMITER //
CREATE PROCEDURE p_gen_tab_parts(
                                )
BEGIN
    DECLARE v_tbn VARCHAR(40);
    DECLARE v_done BOOLEAN DEFAULT FALSE;
    DECLARE cv_tbs CURSOR FOR SELECT tbn FROM wv_tbs;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

    DROP TABLE IF EXISTS wv_tbs;
    CREATE TEMPORARY TABLE wv_tbs
    (
        tbn VARCHAR(40)
    ) ENGINE MEMORY;

    INSERT INTO wv_tbs(tbn)
    VALUES ('alarm_aux_pold')
         , ('alarm_img_data_pold')
         , ('nos_aa_pold')
         , ('nos_ac_pold')
         , ('alarm_pnew')
         , ('alarm_aux_pnew')
         , ('c3_sms_pnew')
         , ('c3_sms_monitor_pnew')
         , ('nos_aa_pnew')
         , ('nos_ac_pnew')
         , ('alarm_edit');

    OPEN cv_tbs;
    floop:
    LOOP
        FETCH cv_tbs INTO v_tbn;
        IF v_done THEN
            LEAVE floop;
        END IF;

        BEGIN
            DECLARE v_start DATETIME(6);
            DECLARE v_end DATETIME(6);
            DECLARE v_CODE VARCHAR(5);
            DECLARE v_msg TEXT;

            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                BEGIN
                    GET DIAGNOSTICS CONDITION 1
                        v_CODE = RETURNED_SQLSTATE,
                        v_msg = MESSAGE_TEXT;
                END;
            SET v_start = now(6);
            CALL p_gen_parts(v_tbn);
            SET v_end = now(6);
            INSERT INTO event_exec_log (event_name, start_time, end_time, stat_code, msg)
            VALUES (concat('part:', v_tbn), v_start, v_end, v_CODE, v_msg);
        END;

    END LOOP;


END //

