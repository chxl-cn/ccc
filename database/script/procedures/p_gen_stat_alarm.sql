DELIMITER ;
DROP PROCEDURE IF EXISTS p_gen_stat_alarm;

DELIMITER //
CREATE PROCEDURE p_gen_stat_alarm(IN p_start DATETIME
                                 , IN p_end  DATETIME
                                 )
BEGIN
    DECLARE v_sql TEXT;

    fstat:
    BEGIN
        DECLARE v_start, v_end DATETIME;
        SET v_start := p_start;

        IF v_start IS NULL
        THEN
            SELECT ifnull(max(running_date) + INTERVAL 1 DAY, 20000101) INTO v_start FROM stat_alarm_ex;
        END IF;

        SET v_end = ifnull(p_end, CURDATE());

        CALL p_get_mod_sql('p_gen_stat_alarm', 1, v_sql);
        SET @fullstmt = v_sql;
        PREPARE fullstmt FROM @fullstmt;
        WHILE v_start < v_end
        DO
            SET @f_sd = v_start;
            SET @f_ed = v_start + INTERVAL 1 DAY;
            EXECUTE fullstmt USING @f_sd,@f_ed;
            SET v_start = v_start + INTERVAL 1 DAY;
        END WHILE;
        DEALLOCATE PREPARE fullstmt;


        DELETE FROM alarm_hist_inc WHERE running_date BETWEEN v_start AND v_end;
    END;

    incstat:
    BEGIN
        DECLARE v_loco VARCHAR(40);
        DECLARE v_rundate DATETIME;
        DECLARE v_done BOOLEAN DEFAULT FALSE;
        DECLARE cur_inc CURSOR FOR SELECT c.running_date, c.locomotive_code
                                   FROM alarm_hist_inc c
                                   GROUP BY c.running_date, c.locomotive_code
                                   ORDER BY 1, 2;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;


        CALL p_get_mod_sql('p_gen_stat_alarm', 2, v_sql);
        SET @incstmt = v_sql;
        PREPARE incstmt FROM @incstmt;

        CALL p_get_mod_sql('p_gen_stat_alarm', 3, v_sql);
        SET @delstmt = v_sql;
        PREPARE delstmt FROM @delstmt;

        OPEN cur_inc;
        fetch_loop:
        LOOP
            FETCH cur_inc INTO v_rundate, v_loco;

            IF v_done THEN
                LEAVE fetch_loop;
            END IF;

            SET @i_dt = v_rundate;
            SET @i_lc = v_loco;

            EXECUTE delstmt USING @i_dt,@i_lc;
            EXECUTE incstmt USING @i_dt,@i_dt,@i_lc;

            DELETE FROM alarm_hist_inc WHERE running_date = v_rundate AND locomotive_code = v_loco;
        END LOOP;

        CLOSE cur_inc;

        DEALLOCATE PREPARE delstmt;
        DEALLOCATE PREPARE incstmt;
    END;


    COMMIT;
END //