DELIMITER ;
DROP PROCEDURE IF EXISTS p_spark;
DELIMITER  //
CREATE PROCEDURE p_spark(IN p_line_code      VARCHAR(100)
                        , IN p_position_code VARCHAR(100)
                        , IN p_direction     VARCHAR(100)
                        , IN p_start_time    DATETIME
                        , IN p_end_time      DATETIME
                        , IN p_page_size     INT
                        , IN p_curr_page     INT
                        , IN p_data_perm     VARCHAR(1000)
                        )
BEGIN
    DECLARE v_spk_sql,v_sms_sql ,v_filter,v_sql TEXT;
    DECLARE v_total_rows INT;
    DECLARE v_space VARCHAR(2) DEFAULT " ";
    DECLARE v_lr VARCHAR(2) DEFAULT char(10);

    SET max_heap_table_size = 17179869184;
    SET group_concat_max_len = 102400;

    SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
    SET v_filter = v_space;
    SET v_filter = concat(v_filter, v_lr, if(p_line_code IS NOT NULL, concat("and line_code='", p_line_code, "'"), v_space));
    SET v_filter = concat(v_filter, v_lr, if(p_position_code IS NOT NULL, concat("and position_code='", p_position_code, "'"), v_space));
    SET v_filter = concat(v_filter, v_lr, if(p_direction IS NOT NULL, concat("and direction='", p_direction, "'"), v_space));
    SET v_filter = concat(v_filter, v_lr, if(p_data_perm IS NOT NULL, concat("and ", p_data_perm), v_space));


    DROP TABLE IF EXISTS wv_spk;
    DROP TABLE IF EXISTS wv_sms_alarm;

    SET @st = p_start_time;
    SET @et = p_end_time;

    CALL p_get_mod_sql('p_spark', 1, v_sql);
    SET @spk = replace(v_sql, '<:filter:>', v_filter);
    PREPARE spkstmt FROM @spk;
    EXECUTE spkstmt USING @st,@et;
    DEALLOCATE PREPARE spkstmt;

    CALL p_get_mod_sql('p_spark', 2, v_sql);
    SET @smstmt = replace(v_sql, '<:filter:>', v_filter);
    PREPARE smstmt FROM @smstmt;
    EXECUTE smstmt USING @st,@et;
    DEALLOCATE PREPARE smstmt;

    ALTER TABLE wv_sms_alarm
        ADD ( spark_cnt INT ,spark_tm DECIMAL,spark_mx DECIMAL,alarm_id VARCHAR(50));

    ALTER TABLE wv_sms_alarm
        ADD PRIMARY KEY (detect_time, locomotive_code, position_code, direction, line_code);

    INSERT INTO wv_sms_alarm(detect_time, locomotive_code, position_code, direction, line_code)
    SELECT raised_time, locomotive_code, position_code, direction, line_code
    FROM wv_spk k
    ON DUPLICATE KEY
        UPDATE spark_cnt=k.spark_cnt, spark_tm=k.spark_tm, spark_mx=k.spark_mx, alarm_id=k.alarm_id;

    DROP TABLE IF EXISTS wv_sms_alarm_out;

    CREATE TEMPORARY TABLE `wv_sms_alarm_out`
    (
        `line_code`       VARCHAR(40) NOT NULL,
        `direction`       VARCHAR(20) NOT NULL,
        `position_code`   VARCHAR(40) NOT NULL,
        `locomotive_code` VARCHAR(30) NOT NULL,
        `detect_time`     DATE        NOT NULL,
        `msc`             DECIMAL(46, 0),
        `avg_speed`       DECIMAL(18, 8),
        `spark_cnt`       INT(11),
        `spark_tm`        DECIMAL(10, 0),
        `spark_mx`        DECIMAL(10, 0),
        `alarm_id`        VARCHAR(50),
        `rwno`            INT(11)
    ) ENGINE = MEMORY;

    INSERT INTO wv_sms_alarm_out
    SELECT a.*, dense_rank() OVER (ORDER BY detect_time DESC, line_code, direction) rwno
    FROM wv_sms_alarm a;

    SELECT max(rwno) INTO v_total_rows FROM wv_sms_alarm_out;
    SET @v_total_rows = v_total_rows;

    DELETE FROM wv_sms_alarm_out k WHERE NOT (rwno > (p_curr_page - 1) * p_page_size AND rwno <= p_curr_page * p_page_size);
    drop TABLE if EXISTS wv_sms_alarm_out1 ;
    CREATE TEMPORARY TABLE wv_sms_alarm_out1 select * from wv_sms_alarm_out ;

    drop TABLE if EXISTS wv_sms_alarm_out2 ;
    CREATE TEMPORARY TABLE wv_sms_alarm_out2 select * from wv_sms_alarm_out ;

    CALL p_get_mod_sql('p_spark', 3, v_sql);
    SET @result = v_sql;
    PREPARE stmt_result FROM @result;
    EXECUTE stmt_result USING @v_total_rows,@v_total_rows,@v_total_rows;
    DEALLOCATE PREPARE stmt_result;


END //