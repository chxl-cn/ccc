DELIMITER  ;
DROP PROCEDURE IF EXISTS p_pw_alrm_stat;

DELIMITER //

CREATE PROCEDURE p_pw_alrm_stat(IN p_bureau_code VARCHAR(100)
                               , IN p_org_code   VARCHAR(100)
                               , IN p_start_date DATETIME
                               , IN p_end_date   DATETIME
                               , IN p_data_perm  VARCHAR(100)
                               )
BEGIN
    DECLARE v_sql,v_where TEXT;

    SET max_heap_table_size = 17179869184;

    SET group_concat_max_len = 10240;

    DROP TABLE IF EXISTS wv_org;

    CALL p_get_mod_sql('p_pw_alrm_stat', 1, v_sql);

    SET v_where = " ";
    SET v_where = concat(v_where, char(10), if(p_bureau_code IS NOT NULL, concat("and sup_org_code='", p_bureau_code, "'"), " "));
    SET v_where = concat(v_where, char(10), if(p_org_code IS NOT NULL, concat("and sup_org_code='", org_code, "'"), " "));

    SET @org = replace(v_sql, "<<:filter:>>", v_where);
    PREPARE stmt_org FROM @org;
    EXECUTE stmt_org;
    DEALLOCATE PREPARE stmt_org;


    DROP TABLE IF EXISTS wv_alt;

    CREATE TEMPORARY TABLE wv_alt ENGINE MEMORY
    SELECT dic_code, if(dic_code = 'AFTEMPDIFF', 'AFOCL', p_code) p_code
    FROM sys_dic d
    WHERE p_code IN ('AFBOWNET', 'AFJHCS', 'AFOCL');


    DROP TABLE IF EXISTS wv_sms;


    CALL p_get_mod_sql('p_pw_alrm_stat', 2, v_sql);

    SET v_where = " ";

    SET v_where = concat(v_where, char(10), if(p_bureau_code IS NOT NULL, concat("and org_code like '", p_bureau_code, "%'"), " "));
    SET v_where = concat(v_where, char(10), if(p_org_code IS NOT NULL, concat("and org_code = '", p_org_code, "'"), " "));
    SET v_where = concat(v_where, char(10), if(p_data_perm IS NOT NULL, concat("and ", p_data_perm), " "));
    SET @sms = replace(v_sql, "<<:filter:>>", v_where);

    PREPARE stmt_sms FROM @sms;
    SET @sd = p_start_date;
    SET @ed = p_end_date;
    EXECUTE stmt_sms USING @sd,@ed;
    DEALLOCATE PREPARE stmt_sms;


    DROP TABLE IF EXISTS wv_alarm;

    CALL p_get_mod_sql('p_pw_alrm_stat', 3, v_sql);

    SET @alarm = replace(v_sql, "<<:filter:>>", v_where);

    PREPARE stmt_alarm FROM @alarm;
    EXECUTE stmt_alarm USING @sd,@ed;
    DEALLOCATE PREPARE stmt_alarm;


    SELECT sup_org_code,
           cast(NULL AS CHAR(40)) sup_org_name,
           cast(NULL AS CHAR(40)) org_name,
           l.locomotive_code,
           l.line_code,
           cast(NULL AS CHAR(40)) line_name,
           l.rtds,
           ifnull(acnt, 0)        acnt,
           ifnull(scnt, 0)        scnt
    FROM (
             SELECT l.sup_org_code,
                    l.org_code,
                    s.locomotive_code,
                    s.line_code,
                    rtds
             FROM wv_org l
                      LEFT JOIN
                  (
                      SELECT locomotive_code,
                             org_code,
                             rtds,
                             group_concat(line_code) line_code
                      FROM (
                               SELECT locomotive_code,
                                      line_code,
                                      org_code,
                                      rtds
                               FROM (
                                        SELECT locomotive_code,

                                               line_code,
                                               org_code,
                                               count(concat(locomotive_code, org_code, rd)) OVER w_rds AS rtds
                                        FROM (
                                                 SELECT s.locomotive_code,
                                                        line_code,
                                                        s.org_code,
                                                        date_format(s.detect_time, '%Y%m%d') rd
                                                 FROM wv_sms s
                                                 GROUP BY date_format(s.detect_time, '%Y%m%d'),
                                                          s.org_code,
                                                          s.locomotive_code,
                                                          line_code
                                             ) v_1
                                            WINDOW w_rds AS ( PARTITION BY locomotive_code,org_code)
                                    ) v_2
                               GROUP BY locomotive_code,
                                        line_code,
                                        org_code,
                                        rtds
                           ) v_3
                      GROUP BY locomotive_code, org_code, rtds
                  ) s
                  ON l.org_code = s.org_code
         ) l
             LEFT JOIN
         (
             SELECT a.org_code,
                    a.detect_device_code,
                    count(*)                                                         acnt,
                    count(if(a.status NOT IN ('AFSTATUS01', 'AFSTATUS02'), 1, NULL)) scnt
             FROM wv_alarm a
             WHERE EXISTS
                       (SELECT NULL
                        FROM wv_alt t
                        WHERE a.code = t.dic_code)
             GROUP BY a.org_code, a.detect_device_code
         ) a
         ON l.org_code = a.org_code
             AND l.locomotive_code = detect_device_code
    ORDER BY 1, 2, 3;


    SELECT CASE
               WHEN p_code = 'AFBOWNET' THEN '燃弧'
               WHEN p_code = 'AFJHCS' THEN '动态几何参数'
               WHEN p_code = 'AFOCL' THEN '接触网温度'
               END dic_code_name,
           group_concat(
                   CASE
                       WHEN detect_device_code IS NOT NULL
                           THEN concat(detect_device_code, '(', cnt, '条)')
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
                 WHERE a.status NOT IN ('AFSTATUS01', 'AFSTATUS02')
             ) a
                                ON l.dic_code = a.code
             GROUP BY p_code, detect_device_code
         ) d
    GROUP BY p_code;


    SELECT cast(NULL AS CHAR(40))                                     line_name,
           line_code,
           group_concat((concat(detect_device_code, '(', cnt, '条)'))) loco_cnt
    FROM (
             SELECT a.line_code,
                    a.detect_device_code,
                    count(*) cnt
             FROM wv_alarm a
             WHERE status NOT IN ('AFSTATUS01', 'AFSTATUS02')
               AND EXISTS
                 (SELECT NULL
                  FROM wv_alt l
                  WHERE l.dic_code = a.code)
             GROUP BY line_code, detect_device_code
         ) a
    GROUP BY line_code;
END //

