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
    )
BEGIN
    DECLARE v_aux_sql,v_img_sql,v_aa_sql,v_ac_sql TEXT;
    DECLARE v_opt,v_dt VARCHAR(20);
    SET v_opt = if(p_sort = 1, ">=", "<");
    SET v_dt = p_date + 0;


    IF p_sort = 0
    THEN
        INSERT INTO nos_aa_pnew SELECT * FROM nos_aa;
        INSERT INTO nos_ac_pnew SELECT * FROM nos_ac;

        DELETE FROM nos_aa_pnew WHERE INPUTDATE >= v_dt;
        DELETE FROM nos_ac_pnew WHERE INPUTDATE >= v_dt;

        #INSERT INTO alarm_aux_pold SELECT * FROM alarm_aux x;
        #INSERT INTO alarm_img_data_pold SELECT * FROM alarm_img_data d;

        #DELETE FROM alarm_aux_pold WHERE raised_time_aux >= v_dt;
        #DELETE FROM alarm_img_data_pold WHERE raise_time >= v_dt;


    ELSE


        INSERT
            INTO nos_aa_pnew
        WITH
            taa_ids AS
                (
            SELECT id
                FROM alarm
                WHERE raised_time >= v_dt
                )
        SELECT a.*
            FROM nos_aa  a
               , taa_ids i
            WHERE a.ID = i.id;


        /*
        INSERT
            INTO alarm_aux_pold
        WITH
            taa_ids AS
                (
            SELECT id
                FROM alarm
                WHERE raised_time >= v_dt
                )
        SELECT a.*
            FROM alarm_aux a
               , taa_ids   i
            WHERE a.alarm_id = i.id;

        INSERT
            INTO alarm_img_data_pold
        WITH
            taa_ids AS
                (
            SELECT id
                FROM alarm
                WHERE raised_time >= v_dt
                )
        SELECT a.*
            FROM alarm_img_data a
               , taa_ids        i
            WHERE a.alarm_id = i.id;
        */

        INSERT
            INTO nos_ac_pnew
        WITH
            tac_ids AS (
            SELECT id
                FROM c3_sms
                WHERE detect_time >= v_dt
                       )
        SELECT c.*
            FROM os_ac   c
               , tac_ids i
            WHERE c.id = i.id;


    END IF;

    BEGIN
        DECLARE v_alarm_sql TEXT;
        DECLARE v_sd DATETIME;
        DECLARE v_ed DATETIME;
        DECLARE v_ov DATETIME;
        SET v_alarm_sql =
                "
                SELECT a.id          id,
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
                         LEFT JOIN alarm_aux x ON a.id = x.alarm_id
                    AND x.raised_time_aux >= ? AND raised_time_aux < ?
                         LEFT JOIN alarm_img_data d ON a.id = d.alarm_id
                    AND d.raise_time >= ? AND d.raise_time < ?
                WHERE a.raised_time >= ?
                  AND a.raised_time < ?
                ";

        DROP TABLE IF EXISTS tmp_mg_alarm;
        SET @stmt_create_tmp_alarm = concat('create table tmp_mg_alarm ', v_alarm_sql);

        SET @sd = 20180101;
        SET @ed = 20180101;

        PREPARE stmt_create_tmp_alarm FROM @stmt_create_tmp_alarm;
        EXECUTE stmt_create_tmp_alarm USING @sd,@ed,@sd,@ed,@sd,@ed;

        DEALLOCATE PREPARE stmt_create_tmp_alarm;

        SET @stmt_insert_tmp_alarm = concat('insert into tmp_mg_alarm ', v_alarm_sql);
        PREPARE stmt_insert_tmp_alarm FROM @stmt_insert_tmp_alarm;

        IF p_sort = 1
        THEN
            SET v_ed = current_date;
            SET v_sd = p_date;
        ELSE
            SET v_ed = v_ed + INTERVAL 1 DAY;
            SET v_sd = "2015-01-01";
        END IF;
        TRUNCATE TABLE tmp_mg_alarm;
        SET @sd = v_sd;
        SET @ed = v_ed;

        EXECUTE stmt_insert_tmp_alarm USING @sd,@ed,@sd,@ed,@sd,@ed;


        INSERT
            INTO alarm_pnew(
                             id
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
            )
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
            FROM tmp_mg_alarm;

        INSERT
            INTO alarm_aux_pnew(
                                 alarm_id
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
            )
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

            FROM tmp_mg_alarm;


        BEGIN
            DECLARE v_ed DATETIME;
            DECLARE v_sd DATETIME;
            DECLARE v_ov DATETIME;
            DECLARE v_sms,v_monitor TEXT;

            SET v_sms =
                    "
                    INSERT INTO c3_sms_pnew(id,
                                            detect_time,
                                            locomotive_code,
                                            bow_status,
                                            p_org_code,
                                            train_no,
                                            pole_code,
                                            pole_no,
                                            log_filename,
                                            gps_course,
                                            gps_speed,
                                            km_mark,
                                            record_time,
                                            line_no,
                                            routing_no,
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
                                            tax_monitor_status,
                                            tax_position,
                                            tax_schedule_status,
                                            version,
                                            invalid_track,
                                            trans_info,
                                            driver_no,
                                            file_location,
                                            backup_file_dir,
                                            relative_path,
                                            log_file_path,
                                            valid_gps)
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
                      AND detect_time < ?;
                    ";


            SET v_monitor =
                    "
                INSERT INTO c3_sms_monitor_pnew(id,
                                                detect_time,
                                                device_group_no,
                                                device_version,
                                                temp_sensor_status,
                                                bow_updown_status,
                                                parallel_span,
                                                env_temp_1,
                                                env_temp_2,
                                                env_temp_3,
                                                env_temp_4,
                                                line_height_1,
                                                line_height_2,
                                                line_height_3,
                                                line_height_4,
                                                irv_temp_1,
                                                irv_temp_2,
                                                irv_temp_3,
                                                irv_temp_4,
                                                pulling_value_1,
                                                pulling_value_2,
                                                pulling_value_3,
                                                pulling_value_4,
                                                is_con_fz,
                                                is_con_ir,
                                                is_con_ov,
                                                is_con_vi,
                                                is_rec_fz,
                                                is_rec_ir,
                                                is_rec_ov,
                                                is_rec_vi,
                                                extra_info)
                SELECT id,
                       detect_time,
                       device_group_no,
                       device_version,
                       temp_sensor_status,
                       bow_updown_status,
                       parallel_span,
                       env_temp_1,
                       env_temp_2,
                       env_temp_3,
                       env_temp_4,
                       line_height_1,
                       line_height_2,
                       line_height_3,
                       line_height_4,
                       irv_temp_1,
                       irv_temp_2,
                       irv_temp_3,
                       irv_temp_4,
                       pulling_value_1,
                       pulling_value_2,
                       pulling_value_3,
                       pulling_value_4,
                       is_con_fz,
                       is_con_ir,
                       is_con_ov,
                       is_con_vi,
                       is_rec_fz,
                       is_rec_ir,
                       is_rec_ov,
                       is_rec_vi,
                       extra_info
                FROM c3_sms
                WHERE detect_time >= ?
                  AND detect_time < ?
                ";

            IF p_sort = 1
            THEN
                SET v_ed = current_date;
                SET v_sd = p_date;
                SET v_ov = v_ed + INTERVAL 1 DAY;
            ELSE
                SET v_ed = "2018-01-02";
                SET v_sd = "2015-01-01";
                SET v_ov = p_date;
            END IF;

            SET @stmt_sms = v_sms;
            SET @stmt_monitor = v_monitor;
            PREPARE stmt_sms FROM @stmt_sms;
            PREPARE stmt_monitor FROM @stmt_monitor;

            lb_sms :
            LOOP
                IF v_sd >= v_ov
                THEN
                    LEAVE lb_sms;
                END IF;

                SET @sd = v_sd;
                SET @ed = v_ed;
                EXECUTE stmt_sms USING @sd,@ed;
                EXECUTE stmt_monitor USING @sd,@ed;

                SET v_sd = v_ed;
                SET v_ed = v_ed + INTERVAL 1 DAY;

            END LOOP;
            DEALLOCATE PREPARE stmt_sms;
            DEALLOCATE PREPARE stmt_monitor;

        END;
    END
    //