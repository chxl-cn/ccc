DELIMITER  ;
DROP PROCEDURE IF EXISTS p_gen_parts;

DELIMITER  //
CREATE PROCEDURE p_gen_parts(IN p_tbn VARCHAR(40)
                            )
BEGIN
    DECLARE v_mx_date,v_up_date DATETIME;
    DECLARE v_sql,v_psql,v_pn,v_pv,v_pd TEXT;

    SET v_up_date = CURRENT_DATE + INTERVAL 1 MONTH;
    SET v_psql = CONCAT("alter table ", p_tbn, " add partition(partition p_:pn values less than (':pv'))");

    SELECT partition_description
    INTO v_pd
    FROM information_schema.partitions p
    WHERE table_name = p_tbn
      AND table_schema = DATABASE()
      AND partition_name != 'p_mx'
    ORDER BY p.partition_ordinal_position DESC
    LIMIT 1;

    SET v_mx_date = replace(v_pd, "'", "");

    WHILE v_mx_date <= v_up_date
    DO
        SET v_mx_date = v_mx_date + INTERVAL 1 DAY;
        SET v_pn = date_format(v_mx_date, '%Y%m%d');
        SET v_pv = date_format(v_mx_date, '%Y-%m-%d');
        SET v_sql = replace(v_psql, ':pn', v_pn);
        SET v_sql = replace(v_sql, ':pv', v_pv);

        SET @sql = v_sql;
        PREPARE stat_partition FROM @sql;
        EXECUTE stat_partition;
        DEALLOCATE PREPARE stat_partition;
    END WHILE;

END //


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
    VALUES ('alarm_aux_mg_part')
         , ('alarm_img_data_mg_part');

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



