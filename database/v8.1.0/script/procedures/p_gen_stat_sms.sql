DELIMITER  ;
DROP PROCEDURE IF EXISTS p_gen_stat_sms;

DELIMITER  //
CREATE PROCEDURE p_gen_stat_sms(IN p_start DATETIME
                               , IN p_end  DATETIME
                               )
BEGIN
    DECLARE v_sql VARCHAR(4000);
    SET max_heap_table_size = 17179869184;

    fstat:
    BEGIN
        DECLARE v_start, v_end DATETIME;
        SET v_start := p_start;

        IF v_start IS NULL THEN
            SELECT ifnull(max(running_date) + INTERVAL '1' DAY, 20140101) INTO v_start FROM stat_sms_ex;
        END IF;

        SET v_end = ifnull(p_end, CURDATE());

        CALL p_get_mod_sql('p_gen_stat_sms', 1, v_sql);
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

        DELETE FROM c3_sms_hist_inc WHERE running_date BETWEEN v_start AND v_end;
    END;


    istat:
    BEGIN
        DECLARE v_rundate DATETIME;
        DECLARE v_lococode VARCHAR(40);
        DECLARE v_done BOOLEAN DEFAULT FALSE;

        DECLARE cur_inc CURSOR FOR SELECT i.running_date, i.locomotive_code
                                   FROM c3_sms_hist_inc i
                                   GROUP BY running_date, locomotive_code
                                   ORDER BY 1, 2;

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

        CALL p_get_mod_sql('p_gen_stat_sms', 2, v_sql);
        SET @incstmt = v_sql;
        PREPARE incstmt FROM @incstmt;

        CALL p_get_mod_sql('p_gen_stat_sms', 3, v_sql);
        SET @delstmt = v_sql;
        PREPARE delstmt FROM @delstmt;


        OPEN cur_inc;

        fetch_loop:
        LOOP
            FETCH cur_inc INTO v_rundate, v_lococode;

            IF v_done THEN
                LEAVE fetch_loop;
            END IF;

            SET @i_st = v_rundate;
            SET @i_et = v_rundate + INTERVAL 1 DAY;
            SET @i_lc = v_lococode;

            EXECUTE delstmt USING @i_st,@i_lc;
            EXECUTE incstmt USING @i_st,@i_et,@i_lc;

            DELETE
            FROM c3_sms_hist_inc
            WHERE running_date = v_rundate
              AND locomotive_code = v_lococode;
        END LOOP;

        CLOSE cur_inc;
        DEALLOCATE PREPARE delstmt;
        DEALLOCATE PREPARE incstmt;

    END;


END //