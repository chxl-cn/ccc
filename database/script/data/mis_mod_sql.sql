INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('loco_curr_stat', 1, 'select id,
       locomotive_code,
       detect_time,
       line_code,
       line_no,
       position_code,
       direction,
       km_mark,
       speed,
       driver_no,
       satellite_num,
       bow_status,
       bureau_code,
       p_org_code,
       recv_time,
       version,
       trans_info,
       power_section_code,
       org_code,
       record_time,
       tax_monitor_status,
       tax_schedule_status,
       tax_position,
       relative_path,
       invalid_track,
       cast(null as char(40))       routing_no,
       cast(null as char(40))       area_no,
       cast(null as char(40))       station_no,
       cast(null as char(40))       station_name,
       cast(null as char(40))       train_no,
       cast(null as char(40))       position_name,
       cast(null as char(20))       line_name,
       cast(null as DECIMAL(12, 8)) gis_lon_o,
       cast(null as DECIMAL(12, 8)) gis_lat_o,
       cast(null as DECIMAL(12, 8)) gis_lon,
       cast(null as DECIMAL(12, 8)) gis_lat,
       null                         bureau_name,
       cast(null as char(40))       p_org_name,
       cast(null as char(40))       log_filename,
       cast(null as char(40))       power_section_name,
       cast(null as char(40))       org_name,
       cast(null as char(40))       pole_code,
       cast(null as char(40))       pole_no,
       ''自有,途经''                  loco_type
from c3_sms s
where id =?
  and detect_time >=? 
  and detect_time <? + interval 1 day');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('loco_curr_stat', 2, 'select id,
       detect_time,
       line_height_1,
       pulling_value_1,
       line_height_2,
       pulling_value_2,
       line_height_3,
       pulling_value_3,
       line_height_4,
       pulling_value_4,
       parallel_span,
       bow_updown_status,
       irv_temp_1,
       env_temp_1,
       irv_temp_2,
       env_temp_2,
       irv_temp_3,
       env_temp_3,
       irv_temp_4,
       env_temp_4,
       temp_sensor_status,
       is_con_ir,
       is_rec_ir,
       is_con_vi,
       is_rec_vi,
       is_con_ov,
       is_rec_ov,
       is_con_fz,
       is_rec_fz,
       extra_info,
       device_version,
       device_group_no
from c3_sms_monitor s
where id =?
  and detect_time >=? 
  and detect_time <? + interval 1 day');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('loco_curr_stat', 3, 'select s.id,
       locomotive_code,
       s.detect_time,
       line_code,
       line_no,
       position_code,
       direction,
       km_mark,
       speed,
       driver_no,
       satellite_num,
       bow_status,
       bureau_code,
       p_org_code,
       recv_time,
       version,
       trans_info,
       power_section_code,
       org_code,
       record_time,
       tax_monitor_status,
       tax_schedule_status,
       tax_position,
       relative_path,
       invalid_track,
       routing_no,
       area_no,
       station_no,
       station_name,
       train_no,
       position_name,
       line_name,
       gis_lon_o,
       gis_lat_o,
       gis_lon,
       gis_lat,
       bureau_name,
       p_org_name,
       log_filename,
       power_section_name,
       org_name,
       pole_code,
       pole_no,
       loco_type,
       line_height_1,
       pulling_value_1,
       line_height_2,
       pulling_value_2,
       line_height_3,
       pulling_value_3,
       line_height_4,
       pulling_value_4,
       parallel_span,
       bow_updown_status,
       irv_temp_1,
       env_temp_1,
       irv_temp_2,
       env_temp_2,
       irv_temp_3,
       env_temp_3,
       irv_temp_4,
       env_temp_4,
       temp_sensor_status,
       is_con_ir,
       is_rec_ir,
       is_con_vi,
       is_rec_vi,
       is_con_ov,
       is_rec_ov,
       is_con_fz,
       is_rec_fz,
       extra_info,
       device_version,
       device_group_no
FROM wv_loco s
         left join wv_sms_mon m
                   on s.id = m.id
ORDER BY s.detect_time DESC');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('loco_stats', 1, 'select id,
       date_format(detect_time, ''%Y-%m-%d %H:%i'')                                                    detect_time,
       locomotive_code                                                                               locomotive_code,
       line_code                                                                                     line_code,
       direction                                                                                     direction,
       km_mark                                                                                       km_mark,
       tax_monitor_status                                                                            tax_monitor_status,
       satellite_num                                                                                 satellite_num,
       ifnull(speed, -1)                                                                             speed,
       dense_rank() over (order by date_format(detect_time, ''%Y-%m-%d %H:%i'') desc, locomotive_code) row_no,
       position_code                                                                                 position_code,
       eoas_direction                                                                                eoas_direction,
       eoas_location                                                                                 eoas_location,
       eoas_time                                                                                     eoas_time,
       cast(null as char(50))                                                                        pole_no,
       cast(null as char(50))                                                                        routing_no,
       cast(null as char(50))                                                                        area_no,
       cast(null as char(50))                                                                        station_no,
       cast(null as decimal(12, 8))                                                                  gis_lon_o,
       cast(null as decimal(12, 8))                                                                  gis_lat_o,
       cast(null as char(50))                                                                        station_name,
       cast(null as char(50))                                                                        train_num
from c3_sms
where detect_time >=?
  and detect_time <=?');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('loco_stats', 2, 'select id,
       irv_temp_1,
       irv_temp_2,
       env_temp_1,
       env_temp_2,
       temp_sensor_status,
       is_con_ir,
       is_rec_ir,
       is_con_vi,
       is_rec_vi,
       is_con_ov,
       is_rec_ov,
       is_con_fz,
       is_rec_fz,
       line_height_1,
       line_height_2,
       pulling_value_1,
       pulling_value_2,
       device_version,
       device_group_no,
       replace(bow_updown_status, ''-1'', ''1'') bow_updown_status,
       extra_info,
       ? loco_code
from c3_sms_monitor
where detect_time >=?
  and detect_time <? + interval 1 day
  and id =?');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('loco_stats', 3, 'SELECT l.id
     , detect_time
     , locomotive_code
     , line_code                                                                line_code
     , cast(NULL AS CHAR(50))                                                   line_name
     , direction
     , satellite_num
     , km_mark
     , pole_no
     , routing_no
     , area_no
     , station_no
     , tax_monitor_status
     , irv_temp
     , env_temp
     , if(regexp_like(port_number, ''端''), port_number, concat(port_number, ''车'')) port_number
     , temp_sensor_status
     , is_con_ir
     , is_rec_ir
     , is_con_vi
     , is_rec_vi
     , is_con_ov
     , is_rec_ov
     , is_con_fz
     , is_rec_fz
     , line_height
     , pulling_value
     , line_height_x
     , pulling_value_x
     , speed
     , gis_lon_o
     , gis_lat_o
     , bow_updown_status
     , total_rows
     , socket1
     , socket2
     , cpu1
     , cpu2
     , position_code                                                            position_code
     , cast(NULL AS CHAR(50))                                                   position_name
     , station_name
     , train_num
     , eoas_direction
     , eoas_location
     , eoas_time
FROM wv_loco l
         LEFT JOIN wv_mvalue v
                   ON l.id = v.id
ORDER BY detect_time DESC
       , locomotive_code
       ');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_alarm_3c_stat', 1, 'CREATE TEMPORARY TABLE t_alarm_3c_stat ENGINE MEMORY
SELECT cast(detect_device_code as CHAR(40)) detect_device_code,
       date_format(t1.raised_time, ''%Y/%m/%d'') AS                 day,
       CASE WHEN count(*) = 0 THEN ''正常'' ELSE ''异常'' END             status,
       count(*)                                                   count,
       sum(CASE WHEN severity = ''一类'' THEN 1 ELSE 0 END)           yl,
       sum(CASE WHEN severity = ''二类'' THEN 1 ELSE 0 END)           el,
       sum(CASE WHEN severity = ''三类'' THEN 1 ELSE 0 END)           sl,
       sum(CASE WHEN t1.code = ''JUDGING'' THEN 1 ELSE 0 END)       dpd,
       sum(CASE WHEN t1.code = ''AFBOWHOT'' THEN 1 ELSE 0 END)      sdgfr,
       sum(CASE WHEN t1.code = ''AFELINKHOT'' THEN 1 ELSE 0 END)    dljxfr,
       sum(CASE WHEN t1.code = ''AFBOWERROR'' THEN 1 ELSE 0 END)    sdgyc,
       sum(CASE WHEN t1.code = ''AFSOFTLINKHOT'' THEN 1 ELSE 0 END) rljxfr,
       sum(CASE WHEN t1.code = ''AFDXHOT'' THEN 1 ELSE 0 END)       dxfr,
       sum(CASE WHEN t1.code = ''AFJUZHOT'' THEN 1 ELSE 0 END)      jyzfr,
       sum(CASE WHEN t1.code = ''AFXJHOT'' THEN 1 ELSE 0 END)       xjfr,
       sum(CASE WHEN t1.code = ''AFHLXHOT'' THEN 1 ELSE 0 END)      hlxfr,
       sum(CASE WHEN t1.code = ''AFJZXHOT'' THEN 1 ELSE 0 END)      jcxfr,
       sum(CASE WHEN t1.code = ''AFLF'' THEN 1 ELSE 0 END)          lh,
       sum(CASE WHEN t1.code = ''AFGDWDLF'' THEN 1 ELSE 0 END)      gdwdslh,
       sum(CASE WHEN t1.code = ''YSGJYQLF'' THEN 1 ELSE 0 END)      gjyqslh,
       sum(CASE WHEN t1.code = ''弓网缺陷'' THEN 1 ELSE 0 END)          gwqx,
       sum(CASE WHEN t1.code = ''AFGXJLF'' THEN 1 ELSE 0 END)       gxjslh
FROM alarm t1
WHERE category_code = ''3C''
  AND status != ''AFSTATUS02''
  AND t1.data_type = ''FAULT''
  AND raised_time BETWEEN ? AND ?
GROUP BY t1.detect_device_code, day');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_c3_sms_trace_stat', 1, 'CREATE TEMPORARY TABLE twv_sms ENGINE MEMORY
SELECT bureau_code     AS bureau_code,
       p_org_code      AS p_org_code,
       org_code        AS org_code,
       locomotive_code AS locomotive_code,
       running_date    AS running_date,
       direction       AS direction,
       ''-1''               routing_no,
       line_code       AS line_code,
       begin_time      AS begin_time,
       end_time        AS end_time
FROM stat_sms_ex
WHERE running_date >=?
  AND running_date < ?
  AND line_code IS NOT NULL
  AND direction IS NOT NULL
  <:filter:>
UNION ALL
SELECT s.bureau_code             AS bureau_code,
       s.p_org_code              AS p_org_code,
       s.org_code                AS org_code,
       s.locomotive_code         AS locomotive_code,
       date(s.detect_time)       AS running_date,
       ifnull(s.direction, ''-1'') AS direction,
       ''-1''                      AS routing_no,
       ifnull(s.line_code, ''-1'') AS line_code,
       min(s.detect_time)        AS begin_time,
       max(s.detect_time)        AS end_time
FROM c3_sms s
WHERE detect_time >=?
  AND detect_time <=?
  AND line_code IS NOT NULL
  AND direction IS NOT NULL
  <:filter:>
GROUP BY s.bureau_code,
    s.p_org_code,
    s.org_code,
    s.locomotive_code,
    running_date,
    direction,
    line_code');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_c3_sms_trace_stat', 2, 'CREATE TEMPORARY TABLE twv_alarm ENGINE MEMORY
SELECT bureau_code        AS bureau_code,
       p_org_code         AS p_org_code,
       org_code           AS org_code,
       locomotive_code    AS locomotive_code,
       running_date       AS running_date,
       direction          AS direction,
       ''-1''               AS routing_no,
       line_code          AS line_code,
       faultalarmcntoflv1 AS faultalarmcntoflv1,
       faultalarmcntoflv2 AS faultalarmcntoflv2,
       faultalarmcntoflv3 AS faultalarmcntoflv3,
       begin_time         AS begin_time,
       end_time           AS end_time
FROM stat_alarm_ex
WHERE running_date >=?
  AND running_date <?
  AND line_code IS NOT NULL
  AND direction IS NOT NULL
  <:filter1:>
UNION ALL
SELECT regexp_substr(cast(p_org_code as char(40)), ''[[:alnum:]]+\\\\$[[:alnum:]]+'', 1, 1) AS bureau_code,
       cast(p_org_code as char(50))                                                     AS p_org_code,
       cast(org_code as char(60))                                                       AS org_code,
       cast(detect_device_code as char(40))                                             AS locomotive_code,
       date(raised_time)                                              AS running_date,
       ifnull(cast(direction as char(20)), ''-1'')                      AS direction,
       ''-1''                                                           AS routing_no,
       ifnull(line_code, ''-1'')                                        AS line_code,
       count(if(severity = ''一类'', 1, NULL))                          AS faultalarmcntoflv1,
       count(if(severity = ''二类'', 1, NULL))                          AS faultalarmcntoflv2,
       count(if(severity = ''三类'', 1, NULL))                          AS faultalarmcntoflv3,
       min(raised_time)                                                  begin_time,
       max(raised_time)                                                  end_time
FROM alarm
WHERE raised_time >=?
  AND raised_time <=?
  AND status != ''AFSTATUS02''
  AND line_code IS NOT NULL
  AND direction IS NOT NULL
  <:filter2:>
GROUP BY bureau_code,
         p_org_code,
         org_code,
         detect_device_code,
         running_date,
         direction,
         line_code');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_gen_stat_alarm', 1, 'INSERT INTO stat_alarm_ex(bureau_code,
                          p_org_code,
                          org_code,
                          locomotive_code,
                          running_date,
                          direction,
                          routing_no,
                          line_code,
                          faultalarmcntoflv1,
                          faultalarmcntoflv2,
                          faultalarmcntoflv3,
                          faultalarmcntoflv1_out,
                          faultalarmcntoflv2_out,
                          faultalarmcntoflv3_out,
                          begin_time,
                          end_time)
SELECT bureau_code,
       p_org_code,
       org_code,
       detect_device_code                                            locomotive_code,
       date(s.raised_time)                                           running_date,
       ifnull(direction, ''-1'')                                       direction,
       ''-1''                                                          routing_no,
       ifnull(line_code, ''-1'')                                       line_code,
       count(if(s.severity = ''一类'', 1, NULL))                         faultalarmcntoflv1,
       count(if(s.severity = ''二类'', 1, NULL))                         faultalarmcntoflv2,
       count(if(s.severity = ''三类'', 1, NULL))                         faultalarmcntoflv3,
       count(if(severity = ''一类'' AND status = ''AFSTATUS03'', 1, NULL)) faultalarmcntoflv1_out,
       count(if(severity = ''二类'' AND status = ''AFSTATUS03'', 1, NULL)) faultalarmcntoflv2_out,
       0                                                             faultalarmcntoflv3_out,
       min(s.raised_time),
       max(s.raised_time)
FROM alarm s
WHERE s.raised_time >= ?
  AND s.raised_time < ?
  AND s.status != ''AFSTATUS02''
  AND line_code IS NOT NULL
  AND direction IS NOT NULL
GROUP BY bureau_code,
         p_org_code,
         org_code,
         detect_device_code,
         running_date,
         direction,
         line_code');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_gen_stat_alarm', 2, 'INSERT INTO stat_alarm_ex(bureau_code,
                          p_org_code,
                          org_code,
                          locomotive_code,
                          running_date,
                          direction,
                          routing_no,
                          line_code,
                          faultalarmcntoflv1,
                          faultalarmcntoflv2,
                          faultalarmcntoflv3,
                          faultalarmcntoflv1_out,
                          faultalarmcntoflv2_out,
                          faultalarmcntoflv3_out,
                          begin_time,
                          end_time)
SELECT bureau_code,
       p_org_code,
       org_code,
       detect_device_code                                            locomotive_code,
       date(raised_time)                                             running_date,
       ifnull(direction, ''-1'')                                       direction,
       ''-1''                                                          routing_no,
       ifnull(line_code, ''-1'')                                       line_code,
       count(if(severity = ''一类'', 1, NULL))                           faultalarmcntoflv1,
       count(if(severity = ''二类'', 1, NULL))                           faultalarmcntoflv2,
       count(if(severity = ''三类'', 1, NULL))                           faultalarmcntoflv3,
       count(if(severity = ''一类'' AND status = ''AFSTATUS03'', 1, NULL)) faultalarmcntoflv1_out,
       count(if(severity = ''二类'' AND status = ''AFSTATUS03'', 1, NULL)) faultalarmcntoflv2_out,
       0                                                             faultalarmcntoflv3_out,
       min(raised_time),
       max(raised_time)
FROM alarm s
WHERE raised_time >= ?
  AND raised_time < ?
  AND detect_device_code = ?
  AND line_code IS NOT NULL
  AND direction IS NOT NULL
  AND status != ''AFSTATUS02''
GROUP BY bureau_code,
         p_org_code,
         org_code,
         detect_device_code,
         running_date,
         direction,
         line_code');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_gen_stat_alarm', 3, 'DELETE
FROM stat_alarm_ex
WHERE running_date = ?
  AND locomotive_code = ?');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_gen_stat_sms', 1, 'INSERT INTO stat_sms_ex(bureau_code,
                        p_org_code,
                        org_code,
                        locomotive_code,
                        running_date,
                        direction,
                        routing_no,
                        line_code,
                        begin_time,
                        end_time,
                        begin_time_out,
                        end_time_out)
SELECT bureau_code,
       p_org_code,
       org_code,
       locomotive_code,
       date(detect_time)                                                 running_date,
       ifnull(direction, ''-1'')                                           direction,
       ifnull(routing_no, ''-1'')                                          routing_no,
       ifnull(line_code, ''-1'')                                           line_code,
       min(detect_time)                                                  begin_time,
       max(detect_time)                                                  end_time,
       min(CASE WHEN ifnull(invalid_track, 0) != 1 THEN detect_time END) begin_time_out,
       max(CASE WHEN ifnull(invalid_track, 0) != 1 THEN detect_time END) end_time_out
FROM c3_sms s
WHERE detect_time >= ?
  AND detect_time < ?
  AND line_code IS NOT NULL
  AND direction IS NOT NULL
GROUP BY bureau_code,
         p_org_code,
         org_code,
         locomotive_code,
         running_date,
         direction,
         routing_no,
         line_code');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_gen_stat_sms', 2, 'INSERT INTO stat_sms_ex(bureau_code,
                        p_org_code,
                        org_code,
                        locomotive_code,
                        running_date,
                        direction,
                        routing_no,
                        line_code,
                        begin_time,
                        end_time,
                        begin_time_out,
                        end_time_out)
SELECT bureau_code,
       p_org_code,
       org_code,
       locomotive_code,
       date(detect_time)                                                 running_date,
       ifnull(direction, ''-1'')                                           direction,
       ifnull(routing_no, ''-1'')                                          routing_no,
       ifnull(line_code, ''-1'')                                           line_code,
       min(detect_time)                                                  begin_time,
       max(detect_time)                                                  end_time,
       min(CASE WHEN ifnull(invalid_track, 0) != 1 THEN detect_time END) begin_time_out,
       max(CASE WHEN ifnull(invalid_track, 0) != 1 THEN detect_time END) end_time_out
FROM c3_sms s
WHERE detect_time >= ?
  AND detect_time < ?
  AND locomotive_code = ?
  AND line_code IS NOT NULL
  AND direction IS NOT NULL
GROUP BY bureau_code,
         p_org_code,
         org_code,
         locomotive_code,
         running_date,
         direction,
         routing_no,
         line_code');
INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_gen_stat_sms', 3, 'DELETE
FROM stat_sms_ex
WHERE running_date = ?
  AND locomotive_code = ?');

INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_spark', 1, 'CREATE TEMPORARY TABLE wv_spk ENGINE MEMORY
SELECT cast(line_code AS CHAR(40))                                                                                      line_code,
       cast(direction AS CHAR(20))                                                                                      direction,
       cast(position_code AS CHAR(50))                                                                                  position_code,
       cast(locomotive_code AS CHAR(30))                                                                                locomotive_code,
       raised_time                                                                                                      raised_time,
       count(DISTINCT id)                                                                                               spark_cnt,
       sum(spark_elapse)                                                                                                spark_tm,
       max(spark_elapse)                                                                                                spark_mx,
       cast(regexp_substr(GROUP_CONCAT(id ORDER BY spark_elapse DESC SEPARATOR '',''), ''[^,]+'') AS CHAR(100))             alarm_id
FROM (
         SELECT a.line_code,
                a.direction,
                a.position_code,
                a.detect_device_code locomotive_code,
                date(raised_time)    raised_time,
                a.id,
                spark_elapse
         FROM alarm a
         WHERE length(a.line_code) > 0
           AND length(a.direction) > 0
           AND length(position_code) > 0
           AND spark_elapse > 0
           AND a.raised_time BETWEEN ? AND ?
           <:filter:>
     ) a
GROUP BY direction,
         position_code,
         line_code,
         locomotive_code,
         raised_time
');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_spark', 2, 'CREATE TEMPORARY TABLE wv_sms_ini ENGINE MEMORY
SELECT dense_rank() OVER (ORDER BY date(detect_time) DESC, line_code, direction) rwno,
       line_code,
       direction,
       position_code,
       locomotive_code,
       date(detect_time)                                                         detect_time,
       sum(msc) * 60000                                                          msc,
       avg(avg_speed)                                                            avg_speed
FROM (SELECT line_code,
             direction,
             position_code,
             locomotive_code,
             date_format(detect_time, ''%Y-%m-%d %H'')                   detect_time,
             TIMESTAMPDIFF(MINUTE, min(detect_time), max(detect_time)) msc,
             avg(speed)                                                avg_speed
      FROM c3_sms s
      WHERE length(line_code) > 0
        AND length(direction) > 0
        AND length(position_code) > 0
        AND detect_time BETWEEN ? AND ?
        AND speed != 0
        <:filter:>
      GROUP BY line_code,
               direction,
               position_code,
               locomotive_code,
               detect_time
     ) s
GROUP BY line_code,
         direction,
         position_code,
         locomotive_code,
         detect_time');