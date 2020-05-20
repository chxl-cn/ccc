DELIMITER  ;
DROP EVENT IF EXISTS event_del_data;

DELIMITER  //
CREATE EVENT event_del_data
    ON SCHEDULE EVERY 1 DAY
    ON COMPLETION PRESERVE
    ENABLE
    COMMENT 'delete data for every day'
    DO
    BEGIN
        /*
        1. trans_data_alarm,trans_data_log 每天定时将过期数据移至trans_hist
        2. log_tracksql,log_request,log_services_status 每天定时删除过期数据
         */
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

        ##01 delete from datacenterlog ;
        SET v_start = now(6);

        DELETE FROM datacenterlog WHERE log_time < curdate() - INTERVAL 7 DAY;

        SET v_end = now(6);
        INSERT INTO event_exec_log(event_name, start_time, end_time, stat_code, msg)
        VALUES ('delete:datacenterlog', v_start, v_end, v_CODE, v_msg);



        ##02 delete from log_tracksql
        SET v_start = now(6);

        DELETE FROM log_tracksql WHERE RequestTime < curdate() - INTERVAL 7 DAY;
        SET v_end = now(6);

        INSERT INTO event_exec_log(event_name, start_time, end_time, stat_code, msg)
        VALUES ('delete:log_tracksql', v_start, v_end, v_CODE, v_msg);


        ##03 delete from log_request
        SET v_start = now(6);

        DELETE FROM log_request WHERE REQUEST_TIME < curdate() - INTERVAL 7 DAY;

        SET v_end = now(6);
        INSERT INTO event_exec_log(event_name, start_time, end_time, stat_code, msg)
        VALUES ('delete:log_request', v_start, v_end, v_CODE, v_msg);


        ##04 delete from log_services_status
        SET v_start = now(6);

        DELETE FROM log_services_status WHERE event_time < curdate() - INTERVAL 7 DAY;

        SET v_end = now(6);
        INSERT INTO event_exec_log(event_name, start_time, end_time, stat_code, msg)
        VALUES ('delete:log_services_status', v_start, v_end, v_CODE, v_msg);



        ##05 migrate data of over time from trans_data_alarm to trans_hist;
        SET v_start = now();

        INSERT INTO trans_hist(id,
                               locomotive_code,
                               data_type,
                               trans_info,
                               trans_result,
                               trans_time,
                               raised_time,
                               use_depot,
                               is_re_syn,
                               is_trans_allowed,
                               confidence_level,
                               is_typical,
                               severity,
                               status,
                               p_org_code,
                               failure_duration,
                               retry_times,
                               trans_loco_orgcode,
                               trans_power_orgcode,
                               trans_view)
        SELECT id,
               locomotive_code,
               data_type,
               'over time' trans_info,
               trans_result,
               trans_time,
               raised_time,
               use_depot,
               is_re_syn,
               is_trans_allowed,
               confidence_level,
               is_typical,
               severity,
               status,
               p_org_code,
               failure_duration,
               retry_times,
               trans_loco_orgcode,
               trans_power_orgcode,
               trans_view
        FROM trans_data_alarm a
        WHERE a.raised_time < curdate() - INTERVAL 7 DAY;

        SET v_end = now(6);
        INSERT INTO event_exec_log(event_name, start_time, end_time, stat_code, msg)
        VALUES ('insert:trans_hist alarm', v_start, v_end, v_CODE, v_msg);



        SET v_start = now(6);

        DELETE FROM trans_data_alarm WHERE raised_time < curdate() - INTERVAL 7 DAY;

        SET v_end = now(6);
        INSERT INTO event_exec_log(event_name, start_time, end_time, stat_code, msg)
        VALUES ('delete:trans_data_alarm', v_start, v_end, v_CODE, v_msg);



        ##06 migrate data of over time from trans_data_log to trans_hist;
        SET v_start = now(6);

        INSERT INTO trans_hist(id,
                               locomotive_code,
                               data_type,
                               trans_info,
                               trans_result,
                               trans_time,
                               raised_time,
                               use_depot,
                               is_re_syn,
                               is_trans_allowed,
                               confidence_level,
                               is_typical,
                               severity,
                               status,
                               p_org_code,
                               failure_duration,
                               retry_times,
                               trans_loco_orgcode,
                               trans_power_orgcode,
                               trans_view)
        SELECT id,
               locomotive_code,
               data_type,
               'over time ' trans_info,
               trans_result,
               trans_time,
               raised_time,
               use_depot,
               is_re_syn,
               is_trans_allowed,
               confidence_level,
               NULL         is_typical,
               NULL         severity,
               NULL         status,
               p_org_code,
               failure_duration,
               retry_times,
               trans_loco_orgcode,
               trans_power_orgcode,
               trans_view
        FROM trans_data_log
        WHERE raised_time < curdate() - INTERVAL 7 DAY;

        SET v_end = now(6);
        INSERT INTO event_exec_log(event_name, start_time, end_time, stat_code, msg)
        VALUES ('insert:trans_hist log', v_start, v_end, v_CODE, v_msg);



        SET v_start = now(6);

        DELETE FROM trans_data_log WHERE raised_time < curdate() - INTERVAL 7 DAY;

        SET v_end = now(6);
        INSERT INTO event_exec_log(event_name, start_time, end_time, stat_code, msg)
        VALUES ('delete:trans_data_log', v_start, v_end, v_CODE, v_msg);

    END //