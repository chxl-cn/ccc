DELIMITER ;
DROP PROCEDURE IF EXISTS loco_stats_pw;

DELIMITER //
CREATE PROCEDURE loco_stats_pw(IN p_bureau_code      VARCHAR(60)
                              , IN p_line_code       VARCHAR(60)
                              , IN p_org_code        VARCHAR(60)
                              , IN p_locomotive_code VARCHAR(60)
                              , IN p_stime           DATETIME
                              , IN p_etime           DATETIME
                              , IN p_position_name   VARCHAR(60)
                              , IN p_position_code   VARCHAR(60)
                              , IN p_direction       VARCHAR(60)
                              , IN p_speed1          DECIMAL
                              , IN p_speed2          DECIMAL
                              , IN p_currpage        INT
                              , IN p_pagesize        INT
                              , IN p_data_perm       VARCHAR(2048)
                              , IN p_skm             DECIMAL
                              , IN p_ekm             DECIMAL
                              )
BEGIN
    DECLARE v_trows INT;
    DECLARE v_where,v_sql TEXT;
    DECLARE v_space VARCHAR(2) DEFAULT " ";
    SET max_heap_table_size = 17179869184;

    SET v_where := v_space;
    SET v_where := concat(v_where, char(10), if(p_line_code IS NOT NULL, concat("and line_code ='", p_line_code, "'"), v_space));
    SET v_where := concat(v_where, char(10), if(p_bureau_code IS NOT NULL, concat("and bureau_code ='", p_bureau_code, "'"), v_space));
    SET v_where := concat(v_where, char(10), if(p_org_code IS NOT NULL, concat("and org_code ='", p_org_code, "'"), " "));
    SET v_where := concat(v_where, char(10), if(p_locomotive_code IS NOT NULL, concat("and locomotive_code ='", p_locomotive_code, "'"), v_space));
    SET v_where := concat(v_where, char(10), if(p_position_name IS NOT NULL, concat("and position_name ='", p_position_name, "'"), v_space));
    SET v_where := concat(v_where, char(10), if(p_position_code IS NOT NULL, concat("and position_code ='", p_position_code, "'"), v_space));
    SET v_where := concat(v_where, char(10), if(p_direction IS NOT NULL, concat("and direction ='", p_direction, "'"), v_space));
    SET v_where := concat(v_where, char(10), if(p_speed1 IS NOT NULL, concat("and speed >=", p_speed1), v_space));
    SET v_where := concat(v_where, char(10), if(p_speed2 IS NOT NULL, concat("and speed <=", p_speed2), v_space));
    SET v_where := concat(v_where, char(10), if(p_skm IS NOT NULL, concat("and km_mark >=", p_skm), v_space));
    SET v_where := concat(v_where, char(10), if(p_ekm IS NOT NULL, concat("and km_mark <=", p_ekm), v_space));
    SET v_where := concat(v_where, char(10), if(p_data_perm IS NOT NULL, concat("and ", p_data_perm), v_space));

    DROP TABLE IF EXISTS wv_loco;

    CALL p_get_mod_sql('loco_stats', 1, v_sql);
    SET v_SQL := concat(v_sql, v_where);
    SET @sql = concat('CREATE TEMPORARY TABLE wv_loco ENGINE memory ', char(10), v_SQL);

    SET @v_st := p_stime;
    SET @v_et := p_etime;
    DROP TABLE IF EXISTS wv_loco;
    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @v_st,@v_et;
    DEALLOCATE PREPARE stmt;

    SELECT count(*)
    INTO v_trows
    FROM (
             SELECT concat(detect_time, locomotive_code)
             FROM wv_loco
             GROUP BY detect_time, locomotive_code
         ) v;

    DELETE FROM wv_loco WHERE NOT (row_no > (p_currpage - 1) * p_pagesize AND row_no <= p_currpage * p_pagesize);

    ALTER TABLE wv_loco
        ADD total_rows INT;
    UPDATE wv_loco SET total_rows = v_trows;


    BEGIN
        DECLARE v_id,v_loco VARCHAR(40);
        DECLARE v_dt DATETIME;
        DECLARE v_done BOOLEAN;
        DECLARE cv_sms CURSOR FOR SELECT id, date(detect_time) detect_time, locomotive_code FROM wv_loco;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

        DROP TABLE IF EXISTS wv_mon;
        CALL p_get_mod_sql('loco_stats', 2, v_sql);
        SET @sql := concat(' create temporary table wv_mon engine memory ', v_sql);
        SET @v_dt := current_date();
        SET @v_id := '-';
        SET @v_loco := '-';
        PREPARE stmt1 FROM @sql;
        EXECUTE stmt1 USING @v_loco, @v_dt,@v_dt,@v_id;
        DEALLOCATE PREPARE stmt1;
        ALTER TABLE wv_mon
            MODIFY loco_code VARCHAR(40);

        SET @sql := concat('insert into wv_mon ', v_sql);
        PREPARE stmt2 FROM @sql;

        OPEN cv_sms;
        SET v_done := FALSE;
        iterate_sms:
        LOOP
            FETCH cv_sms INTO v_id,v_dt,v_loco;
            SET @v_id := v_id;
            SET @v_dt := v_dt;
            SET @v_loco := v_loco;
            IF v_done THEN
                LEAVE iterate_sms ;
            END IF;

            EXECUTE stmt2 USING @v_loco, @v_dt,@v_dt,@v_id;
        END LOOP;
        DEALLOCATE PREPARE stmt2;

    END;

    DROP TABLE IF EXISTS wv_mvalue;
    CREATE TEMPORARY TABLE wv_mvalue
    (
        id                 VARCHAR(60),
        irv_temp           VARCHAR(15),
        env_temp           VARCHAR(15),
        port_number        VARCHAR(10),
        temp_sensor_status VARCHAR(6),
        is_con_ir          VARCHAR(60),
        is_rec_ir          VARCHAR(60),
        is_con_vi          VARCHAR(60),
        is_rec_vi          VARCHAR(60),
        is_con_ov          VARCHAR(60),
        is_rec_ov          VARCHAR(60),
        is_con_fz          VARCHAR(60),
        is_rec_fz          VARCHAR(60),
        line_height        VARCHAR(60),
        pulling_value      VARCHAR(60),
        line_height_x      VARCHAR(60),
        pulling_value_x    VARCHAR(60),
        bow_updown_status  VARCHAR(60),
        socket1            VARCHAR(6),
        socket2            VARCHAR(6),
        cpu1               INT,
        cpu2               INT
    ) ENGINE MEMORY;

    CALL p_parse_smsmv();

    CALL p_get_mod_sql('loco_stats', 3, @sql);
    PREPARE stmt3 FROM @sql;
    EXECUTE stmt3;
    DEALLOCATE PREPARE stmt3;
END //