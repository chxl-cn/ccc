DELIMITER ;
DROP PROCEDURE IF EXISTS p_load_data_proc;


/*
 p_sort :0 历史，1 增量
 */
DELIMITER  //
CREATE PROCEDURE p_load_data_proc
    (
        p_date DATETIME
    ,   p_sort TINYINT
    ,   p_sd   DATETIME
    )
BEGIN
    DECLARE v_goutfile,v_gdmt TEXT;
    DECLARE v_dt VARCHAR(20);
    SET v_dt = p_date + 0;


    SET v_goutfile = "'d:/loaddir/:dir:/:file:.csv'";
    SET v_gdmt = concat(char(10), "fields terminated by '^'", char(10), "lines terminated by '\r\n'");

    SET NAMES utf8mb4;

    DROP TABLE IF EXISTS wv_load;
    CREATE TEMPORARY TABLE wv_load
    ( f  VARCHAR(200) DEFAULT 'load data infile' ,
      fv VARCHAR(200) ,
      t  VARCHAR(200) DEFAULT 'into table' ,
      tv VARCHAR(200) ,
      d  VARCHAR(200) DEFAULT "fields terminated by '^' lines terminated by '\\\\r\\\\n'"
    );

    BEGIN
        DECLARE v_alarm_sql,v_aa_sql,v_sql,v_outfile TEXT;
        DECLARE v_sd,v_ed,v_ov DATETIME;


        SET v_aa_sql = 'select * from nos_aa a where a.INPUTDATE>=? and a.INPUTDATE <? ';

        SET v_alarm_sql =
                'SELECT a.id  id,
                       vendor,
                       category_code,
                       detect_device_code,
                       data_type,
                       dvalue1,
                       dvalue2,
                       dvalue3,
                       dvalue4,
                       dvalue5,
                       nvalue1,
                       nvalue2,
                       nvalue3,
                       nvalue4,
                       nvalue5,
                       nvalue6,
                       nvalue8,
                       nvalue13,
                       nvalue14,
                       nvalue15,
                       nvalue16,
                       created_time,
                       raised_time,
                       report_date,
                       status_time,
                       report_person,
                       is_typical,
                       severity,
                       status,
                       code,
                       cust_alarm_code,
                       p_org_code,
                       svalue8,
                       NULL          svalue14,
                       svalue15,
                       km_mark,
                       pole_number,
                       brg_tun_code,
                       position_code,
                       direction,
                       line_code,
                       org_code,
                       workshop_code,
                       power_section_code,
                       bureau_code,
                       alarm_analysis,
                       task_id,
                       if(length(tax_monitor_status) > 1 ,1,tax_monitor_status) tax_monitor_status,
                       routing_no,
                       area_no,
                       station_no,
                       source,
                       eoas_direction,
                       eoas_km,
                       eoas_location,
                       eoas_time,
                       eoas_train_speed,
                       raised_time_m,
                       tax_position,
                       if(length(tax_schedule_status) > 1,1,tax_schedule_status) tax_schedule_status,
                       pos_confirmed,
                       is_customer_ana,
                       org_file_location,
                       pic_file_location,
                       NULL          summary,
                       repair_date,
                       NULL          isdayreport,
                       isexportreport,
                       lock_person_id,
                       is_trans_allowed,
                       acflag_code,
                       NULL          sample_code,
                       NULL          scencesample_code,
                       accesscount,
                       initial_code,
                       aflg_code,
                       NULL          algcode,
                       reportwordstatus,
                       rerun_type,
                       spark_elapse,
                       isblackcenter,
                       dev_type_ana,
                       NULL          spart_pixel_pct,
                       NULL          spart_pixels,
                       NULL          gray_avg_left,
                       NULL          gray_avg_right,
                       NULL          gray_avg_bow_rect,
                       NULL          spark_shape,
                       NULL          spark_num,
                       NULL          device_id,
                       NULL          eoas_trainno,
                       alarm_rep_count,
                       NULL          sample_detail_code,
                       NULL          valid_gps,
                       NULL          initial_severity,
                       process_status,
                       a.id          alarm_id,
                       bmi_file_name,
                       rpt_file_name,
                       bow_offset,
                       gps_body_direction,
                       img_body_direction,
                       reportwordurl,
                       lock_person_name,
                       lock_time,
                       confidence_level,
                       a.raised_time raised_time_aux,
                       is_abnormal,
                       svalue6,
                       svalue7,
                       svalue10,
                       svalue12,
                       svalue13,
                       alarm_reason,
                       NULL          airesult,
                       remark,
                       trans_info,
                       dev_name,
                       station_name,
                       process_deptname,
                       report_deptname,
                       plan_id,
                       plan_task_id,
                       process_date,
                       process_details,
                       process_overdue,
                       process_person,
                       process_type,
                       profession_type,
                       repaired_pic,
                       repaired_status,
                       repair_method,
                       repair_org,
                       repair_person,
                       report_overdue,
                       review_info,
                       review_person,
                       review_time,
                       check_details,
                       check_person,
                       check_result,
                       harddisk_manage_id,
                       attachment,
                       comp_code,
                       comp_type,
                       nvalue7,
                       nvalue9,
                       nvalue11,
                       nvalue12,
                       nvalue17,
                       nvalue18,
                       nvalue19,
                       nvalue20,
                       power_device_code,
                       power_device_type,
                       substation_code,
                       NULL          map_add_ima,
                       NULL          vi_add_ima,
                       NULL          oa_add_ima
                FROM alarm a
                         LEFT JOIN alarm_aux x
                              ON a.id = x.alarm_id
                                 AND x.raised_time_aux >= ?
                                 AND raised_time_aux < ?
                         LEFT JOIN alarm_img_data d
                               ON a.id = d.alarm_id
                                  AND d.raise_time >= ?
                                  AND d.raise_time < ?
                WHERE a.raised_time >= ?
                  AND a.raised_time < ?
                ';

        DROP TABLE IF EXISTS tmp_mg_alarm;
        SET @stmt_create_tmp_alarm = concat('create table tmp_mg_alarm ', v_alarm_sql);

        SET @sd = 20180101;
        SET @ed = 20180101;

        PREPARE stmt_create_tmp_alarm FROM @stmt_create_tmp_alarm;
        EXECUTE stmt_create_tmp_alarm USING @sd,@ed,@sd,@ed,@sd,@ed;
        DEALLOCATE PREPARE stmt_create_tmp_alarm;


        IF p_sort = 1
        THEN
            SET v_ed = current_date;
            SET v_sd = p_date;
            SET v_ov = v_ed + INTERVAL 1 DAY;
        ELSE
            SET v_sd = p_sd;
            SET v_ed = v_sd + INTERVAL 1 DAY;
            SET v_ov = p_date;
        END IF;

        lbl_alarm:
        LOOP
            IF v_ed > v_ov
            THEN
                LEAVE lbl_alarm;
            END IF;

            SET @sd = v_sd;
            SET @ed = v_ed;


            TRUNCATE TABLE tmp_mg_alarm;
            SET @stmt_insert_tmp_alarm = concat('insert into tmp_mg_alarm ', v_alarm_sql);
            PREPARE stmt_insert_tmp_alarm FROM @stmt_insert_tmp_alarm;
            EXECUTE stmt_insert_tmp_alarm USING @sd,@ed,@sd,@ed,@sd,@ed;
            DEALLOCATE PREPARE stmt_insert_tmp_alarm;

            SET v_sql = '
        SELECT id
             , vendor
             , category_code
             , detect_device_code
             , data_type
             , dvalue1
             , dvalue2
             , dvalue3
             , dvalue4
             , dvalue5
             , nvalue1
             , nvalue2
             , nvalue3
             , nvalue4
             , nvalue5
             , nvalue6
             , nvalue8
             , nvalue13
             , nvalue14
             , nvalue15
             , nvalue16
             , created_time
             , raised_time
             , report_date
             , status_time
             , report_person
             , is_typical
             , severity
             , status
             , code
             , cust_alarm_code
             , p_org_code
             , svalue8
             , svalue14
             , svalue15
             , km_mark
             , pole_number
             , brg_tun_code
             , position_code
             , direction
             , line_code
             , org_code
             , workshop_code
             , power_section_code
             , bureau_code
             , alarm_analysis
             , task_id
             , tax_monitor_status
             , routing_no
             , area_no
             , station_no
             , source
             , eoas_direction
             , eoas_km
             , eoas_location
             , eoas_time
             , eoas_train_speed
             , raised_time_m
             , tax_position
             , tax_schedule_status
             , pos_confirmed
             , is_customer_ana
             , org_file_location
             , pic_file_location
             , summary
             , repair_date
             , isdayreport
             , isexportreport
             , lock_person_id
             , is_trans_allowed
             , acflag_code
             , sample_code
             , scencesample_code
             , accesscount
             , initial_code
             , aflg_code
             , algcode
             , reportwordstatus
             , rerun_type
             , spark_elapse
             , isblackcenter
             , dev_type_ana
             , spart_pixel_pct
             , spart_pixels
             , gray_avg_left
             , gray_avg_right
             , gray_avg_bow_rect
             , spark_shape
             , spark_num
             , device_id
             , eoas_trainno
             , alarm_rep_count
             , sample_detail_code
             , valid_gps
             , initial_severity
             , process_status
            FROM tmp_mg_alarm';

            SET v_outfile = replace(v_goutfile, ':file:', concat('alarm_pnew_', date(v_ed), '_', p_sort));
            SET v_outfile = replace(v_outfile, ':dir:', 'alarm');
            SET v_sql = concat(v_sql, char(10), " into outfile ", v_outfile, v_gdmt);
            SET @alarm_pnew = v_sql;
            PREPARE stmt_alarm_pnew FROM @alarm_pnew;
            EXECUTE stmt_alarm_pnew;
            DEALLOCATE PREPARE stmt_alarm_pnew;

            INSERT
                INTO wv_load(
                              fv
                            , tv
                )
                VALUES
                    (
                        v_outfile
                    ,   'alarm_pnew'
                    );

            SET v_sql = '
        SELECT alarm_id
             , bmi_file_name
             , rpt_file_name
             , bow_offset
             , gps_body_direction
             , img_body_direction
             , reportwordurl
             , lock_person_name
             , lock_time
             , confidence_level
             , raised_time_aux
             , is_abnormal
             , svalue6
             , svalue7
             , svalue10
             , svalue12
             , svalue13
             , alarm_reason
             , airesult
             , remark
             , trans_info
             , dev_name
             , station_name
             , process_deptname
             , report_deptname
             , plan_id
             , plan_task_id
             , process_date
             , process_details
             , process_overdue
             , process_person
             , process_type
             , profession_type
             , repaired_pic
             , repaired_status
             , repair_method
             , repair_org
             , repair_person
             , report_overdue
             , review_info
             , review_person
             , review_time
             , check_details
             , check_person
             , check_result
             , harddisk_manage_id
             , attachment
             , comp_code
             , comp_type
             , nvalue7
             , nvalue9
             , nvalue11
             , nvalue12
             , nvalue17
             , nvalue18
             , nvalue19
             , nvalue20
             , power_device_code
             , power_device_type
             , substation_code
             , map_add_ima
             , vi_add_ima
             , oa_add_ima
             ,null audit_status
            FROM tmp_mg_alarm';

            SET v_outfile = replace(v_goutfile, ':file:', concat('alarm_aux_pnew_', DATE(v_ed), '_', p_sort));
            SET v_outfile = replace(v_outfile, ':dir:', 'alarm_aux');
            SET v_sql = concat(v_sql, char(10), " into outfile ", v_outfile, v_gdmt);
            SET @alarm_aux_pnew = v_sql;
            PREPARE stmt_alarm_aux_pnew FROM @alarm_aux_pnew;
            EXECUTE stmt_alarm_aux_pnew;
            DEALLOCATE PREPARE stmt_alarm_aux_pnew;

            INSERT
                INTO wv_load(
                              fv
                            , tv
                )
                VALUES
                    (
                        v_outfile
                    ,   'alarm_aux_pnew'
                    );


            SET v_sd = v_ed;
            BEGIN
                DECLARE v_td DATETIME;

                SET v_td = v_ed;

                SET v_ed = v_td + INTERVAL 1 WEEK;
                IF v_ed <= v_ov
                THEN
                    ITERATE lbl_alarm;
                END IF;

                SET v_ed = v_td + INTERVAL 1 DAY;
            END;

        END LOOP;


    END;

    BEGIN
        DECLARE v_ed DATETIME;
        DECLARE v_sd DATETIME;
        DECLARE v_ov DATETIME;
        DECLARE v_sms_sql,v_monitor_sql,v_ac_sql, v_sql,v_outfile TEXT;

        SET v_ac_sql = 'select * from nos_ac a where a.INPUTDATE>=? and a.INPUTDATE <? ';
        SET v_sms_sql =
                '
                SELECT id,
                       detect_time,
                       locomotive_code,
                       bow_status,
                       p_org_code,
                       NULL train_no,
                       NULL pole_code,
                       NULL pole_no,
                       NULL log_filename,
                       gps_course,
                       gps_speed,
                       km_mark,
                       record_time,
                       line_no,
                       NULL routing_no,
                       satellite_num,
                       speed,
                       recv_time,
                       line_code,
                       direction,
                       position_code,
                       bureau_code,
                       power_section_code,
                       org_code,
                       eoas_direction,
                       eoas_km,
                       eoas_location,
                       eoas_time,
                       pos_confirmed,
                       if(length(tax_monitor_status) >1 ,1,tax_monitor_status),
                       tax_position,
                       if(length(tax_schedule_status) > 1 ,1, tax_schedule_status),
                       version,
                       invalid_track,
                       trans_info,
                       driver_no,
                       file_location,
                       backup_file_dir,
                       relative_path,
                       NULL log_file_path,
                       NULL valid_gps
                FROM c3_sms
                WHERE detect_time >= ?
                  AND detect_time < ?
                ';


        SET v_monitor_sql =
                '
            SELECT id
                 , detect_time
                 , device_group_no
                 , device_version
                 , temp_sensor_status
                 , bow_updown_status
                 , parallel_span
                 , env_temp_1
                 , env_temp_2
                 , env_temp_3
                 , env_temp_4
                 , line_height_1
                 , line_height_2
                 , line_height_3
                 , line_height_4
                 , irv_temp_1
                 , irv_temp_2
                 , irv_temp_3
                 , irv_temp_4
                 , pulling_value_1
                 , pulling_value_2
                 , pulling_value_3
                 , pulling_value_4
                 , is_con_fz
                 , is_con_ir
                 , is_con_ov
                 , is_con_vi
                 , is_rec_fz
                 , is_rec_ir
                 , is_rec_ov
                 , is_rec_vi
                 , extra_info
            FROM c3_sms
            WHERE detect_time >= ?
              AND detect_time < ?
            ';

        IF p_sort = 1
        THEN
            SET v_ed = current_date;
            SET v_sd = p_date;
            SET v_ov = v_ed + INTERVAL 1 DAY;
        ELSE
            SET v_sd = p_sd;
            SET v_ed = v_sd + INTERVAL 1 DAY;
            SET v_ov = p_date;
        END IF;


        lb_sms :
        LOOP
            IF v_ed > v_ov
            THEN
                LEAVE lb_sms;
            END IF;

            SET @sd = v_sd;
            SET @ed = v_ed;

            SET v_outfile = replace(v_goutfile, ':file:', concat('c3_sms_pnew_', date(v_ed), '_', p_sort));
            SET v_outfile = replace(v_outfile, ':dir:', 'c3_sms');
            SET v_sql = concat(v_sms_sql, char(10), " into outfile ", v_outfile, v_gdmt);
            SET @c3_sms_pnew = v_sql;
            PREPARE stmt_c3_sms_pnew FROM @c3_sms_pnew;
            EXECUTE stmt_c3_sms_pnew USING @sd,@ed;
            DEALLOCATE PREPARE stmt_c3_sms_pnew;

            INSERT
                INTO wv_load(
                              fv
                            , tv
                )
                VALUES
                    (
                        v_outfile
                    ,   'c3_sms_pnew'
                    );


            SET v_outfile = replace(v_goutfile, ':file:', concat('c3_sms_monitor_pnew_', date(v_ed), '_', p_sort));
            SET v_outfile = replace(v_outfile, ':dir:', 'c3_sms_monitor');
            SET v_sql = concat(v_sms_sql, char(10), " into outfile ", v_outfile, v_gdmt);
            SET @c3_sms_monitor_pnew = v_sql;
            PREPARE stmt_c3_sms_monitor_pnew FROM @c3_sms_monitor_pnew;
            EXECUTE stmt_c3_sms_monitor_pnew USING @sd,@ed;
            DEALLOCATE PREPARE stmt_c3_sms_monitor_pnew;

            INSERT
                INTO wv_load(
                              fv
                            , tv
                )
                VALUES
                    (
                        v_outfile
                    ,   'c3_sms_monitor_pnew'
                    );


            SET v_sd = v_ed;
            BEGIN
                DECLARE v_td DATETIME;

                SET v_td = v_ed;

                SET v_ed = v_td + INTERVAL 1 WEEK;
                IF v_ed <= v_ov
                THEN
                    ITERATE lb_sms;
                END IF;

                SET v_ed = v_td + INTERVAL 1 DAY;
            END;
        END LOOP;
    END;

    SELECT concat(f, fv, t, tv, d) FROM wv_load WHERE tv = 'alarm_pnew' INTO OUTFILE 'd:/loaddir/alarm/load_alarm.sql';
    SELECT concat(f, fv, t, tv, d) FROM wv_load WHERE tv = 'alarm_aux_pnew' INTO OUTFILE 'd:/loaddir/alarm_aux/load_alarm_aux.sql';
    SELECT concat(f, fv, t, tv, d) FROM wv_load WHERE tv = 'c3_sms_pnew' INTO OUTFILE 'd:/loaddir/c3_sms/load_c3_sms.sql';
    SELECT concat(f, fv, t, tv, d) FROM wv_load WHERE tv = 'c3_sms_monitor_pnew' INTO OUTFILE 'd:/loaddir/c3_sms_monitor/load_nos_ac.sql';
END //