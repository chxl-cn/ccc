/*
执行脚本前，应xxxxxxxx替换成对应的历史数据日期
 */

DELIMITER  ;

INSERT INTO alarm_aux_mg_part
SELECT alarm_id,
       id,
       bmi_file_name,
       rpt_file_name,
       alarm_rep_count,
       bow_offset,
       gps_body_direction,
       img_body_direction,
       reportwordstatus,
       reportwordurl,
       aflg_code,
       aflg_name,
       isexportreport,
       initial_code,
       initial_code_name,
       accesscount,
       acflag_code,
       acflag_name,
       lock_person_name,
       lock_person_id,
       lock_time,
       is_trans_allowed,
       confidence_level,
       map_add_ima,
       vi_add_ima,
       oa_add_ima,
       sample_code,
       sample_name,
       sample_detail_code,
       sample_detail_name,
       rerun_type,
       raised_time_aux,
       algcode,
       scencesample_code,
       scencesample_name,
       is_abnormal,
       algcodename
FROM (
         SELECT alarm_id,
                id,
                bmi_file_name,
                rpt_file_name,
                alarm_rep_count,
                bow_offset,
                gps_body_direction,
                img_body_direction,
                reportwordstatus,
                reportwordurl,
                aflg_code,
                aflg_name,
                isexportreport,
                initial_code,
                initial_code_name,
                accesscount,
                acflag_code,
                acflag_name,
                lock_person_name,
                lock_person_id,
                lock_time,
                is_trans_allowed,
                confidence_level,
                map_add_ima,
                vi_add_ima,
                oa_add_ima,
                sample_code,
                sample_name,
                sample_detail_code,
                sample_detail_name,
                rerun_type,
                raised_time_aux,
                algcode,
                scencesample_code,
                scencesample_name,
                is_abnormal,
                algcodename,
                row_number() OVER (partition by alarm_id order by raised_time_aux desc ) cnt
         FROM alarm_aux x
         WHERE x.raised_time_aux >= 'xxxxxxxx') t
WHERE cnt = 1;

INSERT INTO alarm_img_data_mg_part
SELECT *
FROM alarm_img_data d
WHERE d.raise_time >= 'xxxxxxxx'
;


