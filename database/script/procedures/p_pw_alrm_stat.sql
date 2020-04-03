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
    DECLARE v_sql TEXT;

    SET max_heap_table_size = 17179869184;

    SET group_concat_max_len = 10240;

    DROP TABLE IF EXISTS wv_org;

    CREATE TEMPORARY TABLE wv_org
        ENGINE MEMORY
    SELECT o.sup_org_code,
           cast(NULL AS CHAR(40)) sup_org_name,
           o.org_code,
           cast(NULL AS CHAR(40)) org_name
    FROM tsys_org o
    WHERE o.org_type LIKE 'GD%'
      AND (p_bureau_code IS NULL OR o.sup_org_code = p_bureau_code)
      AND (p_org_code IS NULL OR o.org_code = p_org_code);

    DROP TABLE IF EXISTS wv_alt;

    CREATE TEMPORARY TABLE wv_alt ENGINE MEMORY
    SELECT dic_code, if(dic_code = 'AFTEMPDIFF', 'AFOCL', p_code) p_code
    FROM sys_dic d
    WHERE p_code IN ('AFBOWNET', 'AFJHCS', 'AFOCL');

    DROP TABLE IF EXISTS wv_sms;

    SET v_sql =
            "CREATE TEMPORARY TABLE wv_sms
             ENGINE memory
             SELECT s.locomotive_code,
                    line_code,
                    s.org_code,
                    detect_time
             FROM c3_sms s
             WHERE s.detect_time BETWEEN :p_start_date AND :p_end_date AND s.speed > 0
             ";

    SET v_sql = replace(v_sql, ':p_start_date', p_start_date + 0);
    SET v_sql = replace(v_sql, ':p_end_date', p_end_date + 0);

    IF p_bureau_code IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and org_code like '", p_bureau_code, "%'");
    END IF;

    IF p_org_code IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and org_code = '", p_org_code, "'");
    END IF;

    IF p_data_perm IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and ", p_data_perm);
    END IF;

    SET @sql = v_sql;

    PREPARE stmt FROM @sql;

    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    DROP TABLE IF EXISTS wv_alarm;

    SET v_sql =
            "
             CREATE TEMPORARY TABLE wv_alarm
             ENGINE memory
             SELECT a.org_code,
                    a.detect_device_code,
                    a.status,
                    line_code,
                    a.code
             FROM alarm a
             WHERE a.raised_time BETWEEN :p_start_date AND :p_end_date
             ";

    SET v_sql = replace(v_sql, ':p_start_date', p_start_date + 0);
    SET v_sql = replace(v_sql, ':p_end_date', p_end_date + 0);

    IF p_bureau_code IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and org_code like '", p_bureau_code, "%'");
    END IF;

    IF p_org_code IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and org_code = '", p_org_code, "'");
    END IF;

    IF p_data_perm IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and ", p_data_perm);
    END IF;

    SET @sql = v_sql;

    PREPARE stmt FROM @sql;

    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


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

