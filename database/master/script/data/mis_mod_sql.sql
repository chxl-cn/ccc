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
       , grp
       , port_number');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_alarm_3c_stat', 1, 'CREATE TEMPORARY TABLE t_alarm_3c_stat ENGINE MEMORY
SELECT cast(detect_device_code AS CHAR(40))                                  detect_device_code,
       date_format(t1.raised_time, ''%Y/%m/%d'') AS                            day,
       if(count(*) = 0 , ''正常'' , ''异常'')                                    status,
       count(*)                                                              count,
       sum(if(severity = ''一类'', 1, 0))                                      yl,
       sum(if(severity = ''二类'', 1, 0))                                      el,
       sum(if(severity = ''三类'', 1, 0))                                      sl,
       sum(if(t1.code = ''JUDGING'', 1, 0))                                    dpd,
       sum(if(t1.code = ''AFBOWHOT'', 1, 0))                                   sdgfr,
       sum(if(t1.code = ''AFELINKHOT'', 1, 0))                                 dljxfr,
       sum(if(t1.code = ''AFBOWERROR'', 1, 0))                                 sdgyc,
       sum(if(t1.code = ''AFSOFTLINKHOT'', 1, 0))                              rljxfr,
       sum(if(t1.code = ''AFDXHOT'', 1, 0))                                    dxfr,
       sum(if(t1.code = ''AFJUZHOT'', 1, 0))                                   jyzfr,
       sum(if(t1.code = ''AFXJHOT'', 1, 0))                                    xjfr,
       sum(if(t1.code = ''AFHLXHOT'', 1, 0))                                   hlxfr,
       sum(if(t1.code = ''AFJZXHOT'', 1, 0))                                   jcxfr,
       sum(if(t1.code = ''AFLF'', 1, 0))                                       lh,
       sum(if(t1.code = ''AFGDWDLF'', 1, 0))                                   gdwdslh,
       sum(if(t1.code = ''YSGJYQLF'', 1, 0))                                   gjyqslh,
       sum(if(t1.code IN (''AFGDWDLF'', ''YSGJYQLF'', ''AFGXJLF'', ''AFLF''), 1, 0)) gwqx,
       sum(if(t1.code = ''AFGXJLF'', 1, 0))                                    gxjslh
FROM alarm t1
WHERE category_code = ''3C''
  AND status != ''AFSTATUS02''
  AND t1.data_type = ''FAULT''
  AND severity != ''三类''
  AND raised_time BETWEEN ? AND ?
  <<:filter:>>
GROUP BY detect_device_code,
        date_format(t1.raised_time, ''%Y/%m/%d'')');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_c3_sms_trace_stat', 1, 'CREATE TEMPORARY TABLE twv_sms ENGINE MEMORY
SELECT bureau_code     AS       bureau_code,
       p_org_code      AS       p_org_code,
       org_code        AS       org_code,
       locomotive_code AS       locomotive_code,
       running_date    AS       running_date,
       direction       AS       direction,
       ifnull(routing_no, ''-1'') routing_no,
       line_code       AS       line_code,
       begin_time      AS       begin_time,
       end_time        AS       end_time
FROM stat_sms_ex
WHERE running_date >= ?
  AND running_date < ?
  AND line_code IS NOT NULL
  AND direction IS NOT NULL
    <:filter:>

UNION ALL

SELECT bureau_code              AS bureau_code,
       p_org_code               AS p_org_code,
       org_code                 AS org_code,
       locomotive_code          AS locomotive_code,
       date(detect_time)        AS running_date,
       ifnull(direction, ''-1'')  AS direction,
       ifnull(routing_no, ''-1'') AS routing_no,
       ifnull(line_code, ''-1'')  AS line_code,
       min(detect_time)         AS begin_time,
       max(detect_time)         AS end_time
FROM c3_sms s
WHERE detect_time >= ?
  AND detect_time <= ?
  AND line_code IS NOT NULL
  AND direction IS NOT NULL
    <:filter:>
GROUP BY bureau_code,
    p_org_code,
    org_code,
    locomotive_code,
    DATE (detect_time),
    ifnull(s.direction, ''-1''),
    ifnull(line_code, ''-1''),
    ifnull(routing_no, ''-1'')');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_c3_sms_trace_stat', 2, 'CREATE TEMPORARY TABLE twv_alarm ENGINE MEMORY
SELECT bureau_code              AS bureau_code,
       p_org_code               AS p_org_code,
       org_code                 AS org_code,
       locomotive_code          AS locomotive_code,
       running_date             AS running_date,
       direction                AS direction,
       ifnull(routing_no, ''-1'') AS routing_no,
       line_code                AS line_code,
       faultalarmcntoflv1       AS faultalarmcntoflv1,
       faultalarmcntoflv2       AS faultalarmcntoflv2,
       faultalarmcntoflv3       AS faultalarmcntoflv3,
       begin_time               AS begin_time,
       end_time                 AS end_time
FROM stat_alarm_ex
WHERE running_date >= ?
  AND running_date < ?
  AND line_code IS NOT NULL
  AND direction IS NOT NULL
  <:filter1:>

UNION ALL

SELECT bureau_code,
       p_org_code,
       org_code,
       locomotive_code,
       running_date,
       direction,
       routing_no,
       line_code,
       count(if(severity = ''一类'', 1, NULL)) AS faultalarmcntoflv1,
       count(if(severity = ''二类'', 1, NULL)) AS faultalarmcntoflv2,
       count(if(severity = ''三类'', 1, NULL)) AS faultalarmcntoflv3,
       min(raised_time)                    AS begin_time,
       max(raised_time)                    AS end_time
FROM (
         SELECT regexp_substr(cast(p_org_code AS CHAR(40)), ''[[:alnum:]]+\\\\$[[:alnum:]]+'', 1, 1) AS bureau_code,
                cast(p_org_code AS CHAR(50))                                                     AS p_org_code,
                cast(org_code AS CHAR(60))                                                       AS org_code,
                cast(detect_device_code AS CHAR(40))                                             AS locomotive_code,
                date(raised_time)                                                                AS running_date,
                ifnull(cast(direction AS CHAR(20)), ''-1'')                                        AS direction,
                ifnull(routing_no, ''-1'')                                                         AS routing_no,
                ifnull(line_code, ''-1'')                                                          AS line_code,
                severity                                                                         AS severity,
                raised_time                                                                      AS raised_time

         FROM alarm
         WHERE raised_time >= ?
           AND raised_time <= ?
           AND status != ''AFSTATUS02''
           AND line_code IS NOT NULL
           AND direction IS NOT NULL
           <:filter2:>
     ) t
GROUP BY bureau_code,
         p_org_code,
         org_code,
         locomotive_code,
         running_date,
         direction,
         line_code,
         routing_no');


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
       ifnull(routing_no, ''-1'')                                      routing_no,
       ifnull(line_code, ''-1'')                                       line_code,
       count(if(s.severity = ''一类'', 1, NULL))                         faultalarmcntoflv1,
       count(if(s.severity = ''二类'', 1, NULL))                         faultalarmcntoflv2,
       count(if(s.severity = ''三类'', 1, NULL))                         faultalarmcntoflv3,
       count(if(severity = ''一类'' AND status = ''AFSTATUS03'', 1, NULL)) faultalarmcntoflv1_out,
       count(if(severity = ''二类'' AND status = ''AFSTATUS03'', 1, NULL)) faultalarmcntoflv2_out,
       0                                                             faultalarmcntoflv3_out,
       min(s.raised_time)                                            begin_time,
       max(s.raised_time)                                            end_time
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
         date(s.raised_time),
         ifnull(direction, ''-1''),
         ifnull(line_code, ''-1''),
         ifnull(routing_no, ''-1'') ');


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
       ifnull(routing_no, ''-1'')                                      routing_no,
       ifnull(line_code, ''-1'')                                       line_code,
       count(if(severity = ''一类'', 1, NULL))                           faultalarmcntoflv1,
       count(if(severity = ''二类'', 1, NULL))                           faultalarmcntoflv2,
       count(if(severity = ''三类'', 1, NULL))                           faultalarmcntoflv3,
       count(if(severity = ''一类'' AND status = ''AFSTATUS03'', 1, NULL)) faultalarmcntoflv1_out,
       count(if(severity = ''二类'' AND status = ''AFSTATUS03'', 1, NULL)) faultalarmcntoflv2_out,
       0                                                             faultalarmcntoflv3_out,
       min(raised_time)                                              begin_time,
       max(raised_time)                                              end_time
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
         date(raised_time),
         ifnull(direction, ''-1''),
         ifnull(line_code, ''-1''),
         ifnull(routing_no, ''-1'') ');


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
         date(detect_time),
         ifnull(direction, ''-1''),
         ifnull(routing_no, ''-1''),
         ifnull(line_code, ''-1'')');


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
         date(detect_time),
         ifnull(direction, ''-1''),
         ifnull(routing_no, ''-1''),
         ifnull(line_code, ''-1'') ');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_gen_stat_sms', 3, 'DELETE
FROM stat_sms_ex
WHERE running_date = ?
  AND locomotive_code = ?');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_pw_alrm_stat', 1, 'CREATE TEMPORARY TABLE wv_org
    ENGINE MEMORY
    SELECT o.sup_org_code
         , cast(NULL AS CHAR(40)) AS sup_org_name
         , o.org_code
         , cast(NULL AS CHAR(40)) AS org_name
         , locomotive_code
        FROM tsys_org                  o
                 INNER JOIN locomotive l
                            ON o.org_code = l.org_code
        WHERE o.org_type LIKE ''GD%''
          <<:filter:>>');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_pw_alrm_stat', 2, 'CREATE TEMPORARY TABLE wv_sms
    ENGINE MEMORY
    SELECT s.locomotive_code
         , line_code
         , detect_time
        FROM c3_sms s
        WHERE s.detect_time BETWEEN ? AND ?
          AND s.speed > 0
          AND exists(SELECT NULL FROM wv_org o WHERE s.locomotive_code = o.locomotive_code)
          <<:filter:>>');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_pw_alrm_stat', 3, 'CREATE TEMPORARY TABLE wv_alarm
    ENGINE MEMORY
    SELECT cast(a.detect_device_code AS CHAR(60)) AS detect_device_code
         , cast(a.status AS CHAR(20))             AS status
         , cast(line_code AS CHAR(40))            AS line_code
         , cast(a.code AS CHAR(40))               AS code
        FROM alarm a
        WHERE a.raised_time BETWEEN ? AND ?
          AND exists(SELECT NULL FROM wv_org o WHERE a.detect_device_code = o.locomotive_code)
          <<:filter:>>');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_pw_alrm_stat', 4, 'SELECT sup_org_code
     , cast(NULL AS CHAR(40)) AS sup_org_name
     , l.org_code
     , cast(NULL AS CHAR(40)) AS org_name
     , l.locomotive_code
     , l.line_code
     , cast(NULL AS CHAR(40)) AS line_name
     , l.rtds
     , ifnull(acnt, 0)        AS acnt
     , ifnull(scnt, 0)        AS scnt
    FROM (
         SELECT l.sup_org_code
              , l.org_code
              , s.locomotive_code
              , s.line_code
              , rtds
             FROM wv_org l
                      LEFT JOIN
                  (
                  SELECT rl.locomotive_code, rl.line_code, rd.rtds
                      FROM wv_sms_ds rd
                         , wv_sms_ln rl
                      WHERE rd.locomotive_code = rl.locomotive_code
                  )      s
                  ON l.locomotive_code = s.locomotive_code
         ) l
             LEFT JOIN
         (
         SELECT a.detect_device_code
              , count(*)                                                            AS acnt
              , count(if(a.status NOT IN ( ''AFSTATUS01'' , ''AFSTATUS02'' ), 1, NULL)) AS scnt
             FROM wv_alarm a
             WHERE EXISTS
                       (SELECT NULL
                            FROM wv_alt t
                            WHERE a.code = t.dic_code)
             GROUP BY a.detect_device_code
         ) a
         ON l.locomotive_code = detect_device_code
    ORDER BY 1
           , 2
           , 3');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_pw_alrm_stat', 5, 'SELECT CASE
           WHEN p_code = ''AFBOWNET'' THEN ''燃弧''
           WHEN p_code = ''AFJHCS'' THEN ''动态几何参数''
           WHEN p_code = ''AFOCL'' THEN ''接触网温度''
           END dic_code_name,
       group_concat(
               CASE
                   WHEN detect_device_code IS NOT NULL
                       THEN concat(detect_device_code, ''('', cnt, ''条)'')
                   END)
               loco_cnt
FROM (
         SELECT p_code,
                detect_device_code,
                count(code) cnt
         FROM wv_alt l
                  LEFT JOIN (
             SELECT a.code,
                    line_code,
                    a.detect_device_code
             FROM wv_alarm a
             WHERE a.status NOT IN (''AFSTATUS01'', ''AFSTATUS02'')
         ) a
                            ON l.dic_code = a.code
         GROUP BY p_code, detect_device_code
     ) d
GROUP BY p_code');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_pw_alrm_stat', 6, 'SELECT cast(NULL AS CHAR(40))                                     line_name,
       line_code,
       group_concat((concat(detect_device_code, ''('', cnt, ''条)''))) loco_cnt
FROM (
         SELECT a.line_code,
                a.detect_device_code,
                count(*) cnt
         FROM wv_alarm a
         WHERE status NOT IN (''AFSTATUS01'', ''AFSTATUS02'')
           AND EXISTS
             (SELECT NULL
              FROM wv_alt l
              WHERE l.dic_code = a.code)
         GROUP BY line_code, detect_device_code
     ) a
GROUP BY line_code');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_spark', 1, 'CREATE TEMPORARY TABLE wv_spk ENGINE MEMORY
SELECT cast(line_code AS CHAR(40))                                                                                      line_code,
       cast(direction AS CHAR(20))                                                                                      direction,
       cast(position_code AS CHAR(50))                                                                                  position_code,
       cast(locomotive_code AS CHAR(30))                                                                                locomotive_code,
       raised_time                                                                                                      raised_time,
       count(*)                                                                                                         spark_cnt,
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
         raised_time');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_spark', 2, 'CREATE TEMPORARY TABLE wv_sms_alarm ENGINE MEMORY
SELECT line_code,
       direction,
       position_code,
       locomotive_code,
       date(detect_time)                                                         detect_time,
       sum(msc) * 1000                                                           msc,
       avg(avg_speed)                                                            avg_speed
FROM (SELECT line_code,
             direction,
             position_code,
             locomotive_code,
             date_format(detect_time, ''%Y-%m-%d %H'')                   detect_time,
             TIMESTAMPDIFF(second, min(detect_time), max(detect_time)) msc,
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
               date_format(detect_time, ''%Y-%m-%d %H'')
     ) s
GROUP BY line_code,
         direction,
         position_code,
         locomotive_code,
         date(detect_time)');


INSERT INTO mis_mod_sql (mod_name, sql_no, sql_text) VALUES ('p_spark', 3, 'SELECT detect_time                                                                                            raised_time,
       line_code                                                                                              line_code,
       direction                                                                                              direction,
       position_code                                                                                          position_code,
       locomotive_code                                                                                        locomotive_code,
       count(DISTINCT locomotive_code)                                                                        loco_cnt,
       sum(spark_cnt)                                                                                         spark_cnt,
       sum(spark_tm)                                                                                          spark_tm,
       round(sum(spark_tm) / nullif(sum(msc), 0) * 100, 5)                                                    spark_rate,
       sum(msc)                                                                                               msc,
       max(spark_mx)                                                                                          spark_mx,
       0                                                                                                      dlevel,
       round(avg(avg_speed), 0)                                                                               avg_speed,
       ?                                                                                                      total_rows,
       cast(regexp_substr(GROUP_CONCAT(alarm_id ORDER BY spark_mx DESC SEPARATOR '',''), ''[^,]+'') AS CHAR(100)) alarm_id
FROM wv_sms_alarm_out a
GROUP BY detect_time,
         line_code,
         direction,
         position_code,
         locomotive_code
UNION ALL
SELECT detect_time                                                                                            raised_time,
       line_code                                                                                              line_code,
       direction                                                                                              direction,
       position_code                                                                                          position_code,
       NULL                                                                                                   locomotive_code,
       count(DISTINCT locomotive_code)                                                                        loco_cnt,
       sum(spark_cnt)                                                                                         spark_cnt,
       sum(spark_tm)                                                                                          spark_tm,
       round(sum(spark_tm) / nullif(sum(msc), 0) * 100, 5)                                                    spark_rate,
       sum(msc)                                                                                               msc,
       max(spark_mx)                                                                                          spark_mx,
       1                                                                                                      dlevel,
       round(avg(avg_speed), 0)                                                                               avg_speed,
       ?                                                                                                      total_rows,
       cast(regexp_substr(GROUP_CONCAT(alarm_id ORDER BY spark_mx DESC SEPARATOR '',''), ''[^,]+'') AS CHAR(100)) alarm_id
FROM wv_sms_alarm_out1 a
GROUP BY detect_time,
         line_code,
         direction,
         position_code
UNION ALL
SELECT detect_time                                                                                            raised_time,
       line_code                                                                                              line_code,
       direction                                                                                              direction,
       NULL                                                                                                   position_code,
       NULL                                                                                                   locomotive_code,
       count(DISTINCT locomotive_code)                                                                        loco_cnt,
       sum(spark_cnt)                                                                                         spark_cnt,
       sum(spark_tm)                                                                                          spark_tm,
       round(sum(spark_tm) / nullif(sum(msc), 0) * 100, 5)                                                    spark_rate,
       sum(msc)                                                                                               msc,
       max(spark_mx)                                                                                          spark_mx,
       3                                                                                                      dlevel,
       round(avg(avg_speed), 0)                                                                               avg_speed,
       ?                                                                                                      total_rows,
       cast(regexp_substr(GROUP_CONCAT(alarm_id ORDER BY spark_mx DESC SEPARATOR '',''), ''[^,]+'') AS CHAR(100)) alarm_id
FROM wv_sms_alarm_out2 a
GROUP BY detect_time,
         line_code,
         direction
ORDER BY raised_time DESC,
         line_code,
         direction,
         position_code,
         dlevel DESC;');