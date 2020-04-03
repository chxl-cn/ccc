DELIMITER  ;
DROP PROCEDURE IF EXISTS p_run_status;

DELIMITER  //
CREATE PROCEDURE p_run_status(IN p_start_date DATETIME
                             , IN p_end_date  DATETIME
                             )
BEGIN
    SET max_heap_table_size = 17179869184;

    WITH wv_loco AS
             (
                 SELECT bureau_code,
                        p_org_code,
                        cast(NULL AS CHAR(40)) bureau_name,
                        cast(NULL AS CHAR(50)) p_org_name,
                        locomotive_code,
                        device_version,
                        cast(NULL AS CHAR(40)) code_name
                 FROM locomotive ll
                          LEFT JOIN sys_dic d
                                    ON ll.device_version = d.dic_code
             ),

         alarm_agg AS
             (
                 SELECT t.detect_device_code,
                        t.bureau_code,
                        t.p_org_code,
                        cast(NULL AS CHAR(40))                                                                                                                          bureau_name,
                        cast(NULL AS CHAR(50))                                                                                                                          p_org_name,
                        sum(if(d.p_code = 'AFBOWNET', 1, 0))                                                                                                            gwqx,
                        sum(if(d.p_code = 'AFBOW', 1, 0))                                                                                                               sdgqx,
                        sum(if(d.p_code = 'AFOCL', 1, 0))                                                                                                               jcwqx,
                        sum(if(d.dic_code = 'AFCODEOTHER', 1, 0))                                                                                                       qt,
                        sum(if(d.dic_code = 'AFGR', 1, 0))                                                                                                              gr,
                        count(*)                                                                                                                                        bjl,
                        max(greatest(dvalue1, dvalue2))                                                                                                                 raised_time,
                        truncate(avg(if(dvalue1 > 20100101 AND timestampdiff(HOUR, dvalue1, t.raised_time) > 3, timestampdiff(HOUR, dvalue1, t.raised_time), NULL)), 2) dv1,
                        truncate(avg(if(dvalue2 > 20100101 AND timestampdiff(HOUR, dvalue2, t.raised_time) > 3, timestampdiff(HOUR, dvalue2, t.raised_time), NULL)), 2) dv2,
                        truncate(avg(if(dvalue3 > 20100101 AND timestampdiff(HOUR, dvalue3, t.raised_time) > 3, timestampdiff(HOUR, dvalue3, t.raised_time), NULL)), 2) dv3,
                        truncate(avg(if(dvalue4 > 20100101 AND timestampdiff(HOUR, dvalue4, t.raised_time) > 3, timestampdiff(HOUR, dvalue4, t.raised_time), NULL)), 2) dv4,
                        truncate(avg(if(dvalue5 > 20100101 AND timestampdiff(HOUR, dvalue5, t.raised_time) > 3, timestampdiff(HOUR, dvalue5, t.raised_time), NULL)), 2) dv5
                 FROM alarm t
                          LEFT JOIN sys_dic d
                                    ON greatest(dvalue1, dvalue2) >= date(p_start_date)
                                        AND greatest(dvalue1, dvalue2) < date(p_end_date) + INTERVAL '1' DAY
                                        AND t.code = d.dic_code
                 GROUP BY t.detect_device_code, t.bureau_code, t.p_org_code
             ),

         sms_agg AS
             (
                 SELECT s.bureau_code,
                        s.p_org_code,
                        cast(NULL AS CHAR(40))                                                                          bureau_name,
                        cast(NULL AS CHAR(50))                                                                          p_org_name,
                        s.locomotive_code,
                        max(if(detect_time BETWEEN date(p_start_date) - 7 AND date(p_end_date) + 1, detect_time, NULL)) last_date,
                        if(date(max(detect_time)) = date(p_start_date), '运行', '检修')                                     yxzt
                 FROM c3_sms s
                 WHERE detect_time >= date_add(date(p_start_date), INTERVAL -3 MONTH)
                   AND detect_time < date(p_end_date) + INTERVAL '1' DAY
                 GROUP BY s.bureau_code, s.p_org_code, s.locomotive_code
             )

    SELECT l.bureau_name,
           l.p_org_name,
           l.code_name                                              device_version,
           l.locomotive_code,
           gwqx,
           sdgqx,
           jcwqx,
           qt,
           gr,
           bjl,
           if(bjl - gwqx - sdgqx - jcwqx - qt - gr = 0, 'ok', NULL) zt,
           raised_time,
           last_date,
           dv1,
           dv2,
           dv3,
           dv4,
           dv5,
           if(yxzt IS NULL, '停运', yxzt)                             yxzt
    FROM wv_loco l
             LEFT JOIN alarm_agg
                       ON l.bureau_code = alarm_agg.bureau_code
                           AND l.p_org_code = alarm_agg.p_org_code
                           AND l.locomotive_code = alarm_agg.detect_device_code
             LEFT JOIN sms_agg
                       ON l.bureau_code = sms_agg.bureau_code
                           AND l.p_org_code = sms_agg.p_org_code
                           AND l.locomotive_code = sms_agg.locomotive_code
    ORDER BY l.bureau_code, p_org_code, locomotive_code;


END //