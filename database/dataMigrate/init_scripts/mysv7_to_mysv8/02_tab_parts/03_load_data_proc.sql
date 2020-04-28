DELIMITER ;
DROP PROCEDURE IF EXISTS p_load_data_proc;


/*
 p_sort :0 历史，1 增量
 */
DELIMITER  //
CREATE PROCEDURE p_load_data_proc(p_date  DATETIME
                                 , p_sort TINYINT
                                 )
BEGIN
    DECLARE v_aux_sql,v_img_sql,v_aa_sql,v_ac_sql TEXT;
    DECLARE v_opt,v_dt VARCHAR(20);
    SET v_opt = if(p_sort = 1, ">=", "<");
    SET v_dt = p_date + 0;


    SET v_aux_sql = concat("INSERT INTO alarm_aux_pold SELECT * FROM alarm_aux x WHERE x.raised_time_aux  ", v_opt, v_dt);
    SET v_img_sql = concat("INSERT INTO alarm_img_data_pold  SELECT * FROM alarm_img_data d WHERE d.raise_time  ", v_opt, v_dt);
    SET v_aa_sql = concat("INSERT INTO nos_aa_pnew  SELECT * FROM nos_aa a WHERE a.INPUTDATE  ", v_opt, v_dt);
    SET v_ac_sql = concat("INSERT INTO nos_ac_pnew SELECT * FROM nos_ac c WHERE c.INPUTDATE  ", v_opt, v_dt);

    SET @stmt = v_aux_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @stmt = v_img_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @stmt = v_aa_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @stmt = v_ac_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    BEGIN
        DECLARE v_alarm_sql TEXT;
        DECLARE v_sd DATETIME;
        DECLARE v_ed DATETIME;
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
                       tax_monitor_status,
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
                       tax_schedule_status,
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
                         LEFT JOIN alarm_aux_pold x ON a.id = x.alarm_id
                    AND x.raised_time_aux >= ? AND raised_time_aux < ?
                         LEFT JOIN alarm_img_data_pold d ON a.id = d.alarm_id
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

        IF p_sort = 1 THEN
            SET v_ed = p_date + INTERVAL 1 DAY;
            SET v_sd = p_date;
        ELSE
            SET v_ed = p_date;
            SET v_sd = "2015-01-01";

        END IF;

        IF p_sort = 1 THEN
            SET v_sd = p_date;
            lb_alarm_inc :
            LOOP
                IF v_sd > current_date + INTERVAL 1 DAY THEN
                    LEAVE lb_alarm_inc;
                END IF;

                TRUNCATE TABLE tmp_mg_alarm;
                SET v_ed := v_sd + INTERVAL 1 DAY;
                SET @sd = v_sd;
                SET @ed = v_ed;

                EXECUTE stmt_create_tmp_alarm USING @sd,@ed,@sd,@ed,@sd,@ed;


                SET v_sd = v_ed;
                SET v_ed = v_ed + INTERVAL 1 DAY;
            END LOOP;
        ELSE
        END IF;

    END;
END
//