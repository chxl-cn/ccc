DELIMITER  ;
DROP PROCEDURE IF EXISTS p_c3_sms_trace_stat_ln;

DELIMITER  //
CREATE PROCEDURE p_c3_sms_trace_stat_ln(IN p_line_code        VARCHAR(60)
                                       , IN p_locomotive_code VARCHAR(60)
                                       , IN p_start_date      DATETIME
                                       , IN p_end_date        DATETIME
                                       , IN p_pagesize        INT
                                       , IN p_currpage        INT
                                       , OUT p_total_recs     INT
                                       , OUT p_total_pages    INT
                                       , IN p_data_perm       VARCHAR(2048)
                                       )
BEGIN
    DECLARE v_sql, v_filter TEXT;
    DECLARE v_hist_edate, v_curr_sdate DATETIME;
    DECLARE v_space VARCHAR(2) DEFAULT " ";

    SET max_heap_table_size = 17179869184;
    SET v_hist_edate = if(p_end_date > CURRENT_DATE, CURRENT_DATE, p_end_date);
    SET v_curr_sdate = if(p_start_date < CURRENT_DATE, CURRENT_DATE, p_start_date);

    SET @h_sd = p_start_date;
    SET @h_ed = v_hist_edate;
    SET @c_sd = v_curr_sdate;
    SET @c_ed = p_end_date;
    SET @stmt_sms = v_sql;

    SET v_filter = " ";
    SET v_filter = concat(v_filter, char(10), if(p_line_code IS NOT NULL, concat("and line_code = '", p_line_code, "'"), v_space));
    SET v_filter = concat(v_filter, char(10), if(p_locomotive_code IS NOT NULL, concat("and locomotive_code = '", p_locomotive_code, "'"), v_space));
    SET v_filter = concat(v_filter, char(10), if(p_data_perm IS NOT NULL, concat("and ", p_data_perm), v_space));


    DROP TABLE IF EXISTS twv_sms;
    CALL p_get_mod_sql('p_c3_sms_trace_stat', 1, v_sql);
    SET v_sql = replace(v_sql, '<:filter:>', v_filter);
    SET @stmt_sms = v_sql;
    PREPARE stmt_sms FROM @stmt_sms;
    EXECUTE stmt_sms USING @h_sd,@h_ed,@c_sd,@c_ed;
    DEALLOCATE PREPARE stmt_sms;


    DROP TABLE IF EXISTS twv_alarm;
    CALL p_get_mod_sql('p_c3_sms_trace_stat', 2, v_sql);
    SET v_sql = replace(v_sql, '<:filter1:>', v_filter);
    SET v_filter = replace(v_filter, 'and locomotive_code', ' and detect_device_code');
    SET v_sql = replace(v_sql, '<:filter2:>', v_filter);

    SET @stmt_alarm = v_sql;
    PREPARE stmt_alarm FROM @stmt_alarm;
    EXECUTE stmt_alarm USING @h_sd,@h_ed,@c_sd,@c_ed;
    DEALLOCATE PREPARE stmt_alarm;


    DROP TABLE IF EXISTS wv_sms_alarm;

    CREATE TEMPORARY TABLE wv_sms_alarm
        ENGINE MEMORY
    SELECT locomotive_code,
           running_date,
           direction,
           routing_no,
           line_code,
           sum(faultalarmcntoflv1) faultalarmcntoflv1,
           sum(faultalarmcntoflv2) faultalarmcntoflv2,
           sum(faultalarmcntoflv3) faultalarmcntoflv3,
           min(begin_time)         begin_time,
           max(end_time)           end_time
    FROM twv_alarm
    GROUP BY locomotive_code,
             running_date,
             direction,
             routing_no,
             line_code;


    ALTER TABLE wv_sms_alarm
        ADD CONSTRAINT ix_p PRIMARY KEY
            (locomotive_code,
             running_date,
             direction,
             routing_no,
             line_code);

    INSERT INTO wv_sms_alarm(locomotive_code,
                             running_date,
                             direction,
                             routing_no,
                             line_code,
                             begin_time,
                             end_time)
    SELECT locomotive_code,
           running_date,
           direction,
           routing_no,
           line_code,
           min(begin_time) st,
           max(end_time)   et
    FROM twv_sms
    GROUP BY locomotive_code,
             running_date,
             direction,
             routing_no,
             line_code
    ON DUPLICATE KEY UPDATE begin_time = if(st < begin_time, st, begin_time),
                            end_time   = if(et > end_time, et, end_time);


    DROP TABLE IF EXISTS wv_agg_sms_alarm;

    CREATE TEMPORARY TABLE wv_agg_sms_alarm
        ENGINE MEMORY
    SELECT locomotive_code,
           running_date,
           direction,
           line_code,
           min(begin_time)                 AS begin_time,
           max(end_time)                   AS end_time,
           sum(faultalarmcntoflv1)         AS faultalarmcntoflv1,
           sum(faultalarmcntoflv2)         AS faultalarmcntoflv2,
           sum(faultalarmcntoflv3)         AS faultalarmcntoflv3,
           0                               AS grpl,
           count(DISTINCT locomotive_code) AS loco_count
    FROM wv_sms_alarm
    GROUP BY locomotive_code,
             running_date,
             direction,
             line_code;

    INSERT INTO wv_agg_sms_alarm(running_date,
                                 direction,
                                 line_code,
                                 begin_time,
                                 end_time,
                                 faultalarmcntoflv1,
                                 faultalarmcntoflv2,
                                 faultalarmcntoflv3,
                                 grpl,
                                 loco_count, locomotive_code)
    SELECT running_date,
           direction,
           line_code,
           min(begin_time)                 begin_time,
           max(end_time)                   end_time,
           sum(faultalarmcntoflv1)         faultalarmcntoflv1,
           sum(faultalarmcntoflv2)         faultalarmcntoflv2,
           sum(faultalarmcntoflv3)         faultalarmcntoflv3,
           1                               grpl,
           count(DISTINCT locomotive_code) loco_count,
           " "                             locomotive_code
    FROM wv_sms_alarm
    GROUP BY running_date, direction, line_code;

    DROP TABLE IF EXISTS t_agg_sms_alarm;

    CREATE TEMPORARY TABLE t_agg_sms_alarm
        ENGINE MEMORY
    SELECT locomotive_code,
           running_date,
           direction,
           line_code,
           begin_time,
           end_time,
           faultalarmcntoflv1,
           faultalarmcntoflv2,
           faultalarmcntoflv3,
           grpl,
           loco_count,
           dense_rank() OVER wr AS rown
    FROM wv_agg_sms_alarm
        WINDOW wr AS (ORDER BY running_date DESC, line_code, direction )
    ORDER BY rown;

    SELECT max(rown) INTO p_total_recs FROM t_agg_sms_alarm;

    SET p_total_recs := ifnull(p_total_recs, 0);
    SET p_total_pages := ceil(p_total_recs / p_pagesize);
    SET p_total_pages := ifnull(p_total_pages, 1);

    SELECT line_code,
           cast(NULL AS CHAR(40))        line_name,
           direction,
           running_date,
           begin_time,
           end_time,
           ifnull(faultalarmcntoflv1, 0) faultalarmcntoflv1,
           ifnull(faultalarmcntoflv2, 0) faultalarmcntoflv2,
           ifnull(faultalarmcntoflv3, 0) faultalarmcntoflv3,
           rown,
           loco_count
    FROM t_agg_sms_alarm t
    WHERE rown > (p_currpage - 1) * p_pagesize
      AND rown <= p_currpage * p_pagesize
      AND grpl = 1
    ORDER BY rown;

    SELECT locomotive_code,
           running_date,
           begin_time,
           end_time,
           ifnull(faultalarmcntoflv1, 0) faultalarmcntoflv1,
           ifnull(faultalarmcntoflv2, 0) faultalarmcntoflv2,
           ifnull(faultalarmcntoflv3, 0) faultalarmcntoflv3,
           rown
    FROM t_agg_sms_alarm
    WHERE rown > (p_currpage - 1) * p_pagesize
      AND rown <= p_currpage * p_pagesize
      AND grpl != 1
    ORDER BY locomotive_code, running_date DESC;

END //