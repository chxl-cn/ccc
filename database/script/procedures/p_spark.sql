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
    DROP TABLE IF EXISTS wv_sms_ini;

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

    DROP TABLE IF EXISTS wv_sms_ini__;
    DROP TABLE IF EXISTS wv_sms;


    CREATE TEMPORARY TABLE wv_sms LIKE wv_sms_ini;
    CREATE TEMPORARY TABLE wv_sms_ini__ LIKE wv_sms_ini;

    INSERT INTO wv_sms_ini__
    SELECT *
    FROM wv_sms_ini;

    ALTER TABLE wv_sms_ini__
        ADD KEY (detect_time, locomotive_code, direction );

    INSERT INTO wv_sms_ini(line_code, direction, position_code, detect_time, locomotive_code)
    SELECT line_code, direction, position_code, raised_time, locomotive_code
    FROM wv_spk k
    WHERE NOT exists
        (
            SELECT NULL
            FROM wv_sms_ini__ i
            WHERE i.line_code = k.line_code
              AND i.direction = k.direction
              AND i.position_code = k.position_code
              AND i.detect_time = k.raised_time
              AND i.locomotive_code = k.locomotive_code
        )
    GROUP BY line_code, direction, position_code, raised_time, locomotive_code;


    INSERT INTO wv_sms
    SELECT dense_rank() OVER (ORDER BY detect_time DESC, line_code, direction) rwno,
           line_code,
           direction,
           position_code,
           locomotive_code,
           detect_time,
           msc,
           avg_speed
    FROM wv_sms_ini;


    SELECT max(rwno) INTO v_total_rows FROM wv_sms;

    DROP TABLE IF EXISTS wv_sms_alarm;
    CREATE TEMPORARY TABLE wv_sms_alarm ENGINE MEMORY
    SELECT * FROM wv_sms k WHERE rwno > (p_curr_page - 1) * p_page_size AND rwno <= p_curr_page * p_page_size;

    ALTER TABLE wv_sms_alarm
        ADD KEY (detect_time, locomotive_code, direction );


    SELECT *
    FROM (
             SELECT detect_time                                                                                       raised_time,
                    line_code                                                                                         line_code,
                    direction                                                                                         direction,
                    position_code                                                                                     position_code,
                    locomotive_code                                                                                   locomotive_code,
                    count(DISTINCT locomotive_code)                                                                   loco_cnt,
                    sum(spark_cnt)                                                                                    spark_cnt,
                    sum(spark_tm)                                                                                     spark_tm,
                    round(sum(spark_tm) / nullif(sum(msc), 0) * 100, 5)                                               spark_rate,
                    sum(msc)                                                                                          msc,
                    max(smx)                                                                                          spark_mx,
                    GROUPING (detect_time
                     , line_code
                     , direction
                     , position_code
                     , locomotive_code)                                                                               dlevel
                     ,round(avg(avg_speed), 0)                                                                        avg_speed,
                    v_total_rows                                                                                      total_rows,
                    cast(regexp_substr(GROUP_CONCAT(alarm_id ORDER BY smx DESC SEPARATOR ','), '[^,]+') AS CHAR(100)) alarm_id
             FROM (
                      SELECT k.detect_time,
                             k.line_code,
                             k.direction,
                             k.position_code,
                             k.locomotive_code,
                             msc,
                             spark_tm,
                             spark_cnt,
                             alarm_id,
                             spark_mx smx,
                             avg_speed
                      FROM wv_spk s
                               RIGHT JOIN wv_sms_alarm k
                                          ON s.line_code = k.line_code
                                              AND s.locomotive_code = k.locomotive_code
                                              AND s.direction = k.direction
                                              AND s.position_code = k.position_code
                                              AND s.raised_time = k.detect_time
                  ) a
             GROUP BY detect_time,
                      line_code,
                      direction,
                      position_code,
                      locomotive_code
             WITH ROLLUP
             having GROUPING (detect_time
                     , line_code
                     , direction
                     , position_code
                     , locomotive_code)  < 7
         ) s
    ORDER BY raised_time DESC,
             line_code,
             direction,
             position_code,
             dlevel DESC;



END //