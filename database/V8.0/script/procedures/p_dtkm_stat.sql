DELIMITER  ;
DROP PROCEDURE IF EXISTS p_dtkm_stat;
DELIMITER  //
CREATE PROCEDURE p_dtkm_stat(IN p_bureau_code VARCHAR(100)
                            , IN p_org_code   VARCHAR(100)
                            , IN p_start_date DATETIME
                            , IN p_end_date   DATETIME
                            , IN p_stat_codes VARCHAR(100)
                            , IN p_data_perm  VARCHAR(1000)
                            )
BEGIN
    DECLARE v_sql TEXT;

    SET max_heap_table_size = 17179869184;
    DROP TABLE IF EXISTS wv_code;

    CREATE TEMPORARY TABLE wv_code
        ENGINE MEMORY
    SELECT dic_code,
           CASE
               WHEN (p_code = 'AFBOWNET'
                   AND dic_code NOT IN ('YSDWDLH',
                                        'AFLF',
                                        'AFTEMPDIFF',
                                        'AFGDWDLF',
                                        'YSGJYQLF',
                                        'AFGXJLF',
                                        'AFBOWNETLCA',
                                        'AFBOWNETACA',
                                        'AFBOWNETHCA',
                                        'AFCODELMTSPARK')
                        )
                   OR (p_code = 'AFOCL'
                       AND dic_code NOT IN ('AFELINKHOT',
                                            'AFDXHOT',
                                            'AFHLXHOT',
                                            'AFJZXHOT',
                                            'AFJUZHOT',
                                            'AFXJHOT',
                                            'AFCODEXFR',
                                            'AFCODEJFR')
                        )
                   THEN
                   'AFOTHOPS'
               ELSE
                   p_code
               END
               p_code
    FROM sys_dic
    WHERE category = 'AFCODE';


    SET v_sql = "
    create TEMPORARY table wv_org engine memory
    select org_code
      from tsys_org
     where org_type like 'GD%'
";

    IF p_bureau_code IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and sup_org_code='", p_bureau_code, "'");
    END IF;

    IF p_org_code IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and org_code='", p_org_code, "'");
    END IF;


    DROP TABLE IF EXISTS wv_org;

    SET @sql = v_sql;

    PREPARE stmt FROM @sql;

    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


    DROP TABLE IF EXISTS wv_stats;

    CREATE TEMPORARY TABLE wv_stats
        ENGINE MEMORY
    SELECT d.dic_code
    FROM sys_dic d
    WHERE d.p_code = 'AFSTATUS';

    IF p_stat_codes IS NOT NULL
    THEN
        DELETE
        FROM wv_stats
        WHERE p_stat_codes NOT LIKE concat("%", dic_code, "%");
    END IF;


    DROP TABLE IF EXISTS wv_sms_v1;

    SET v_sql =
            "
      create TEMPORARY table  wv_sms_v1 engine memory
      select  s.org_code,
              s.bureau_code,
              s.line_code,
              s.direction,
              s.locomotive_code,
              s.gis_lon_o curr_lon,
              s.gis_lat_o curr_lat,
              lead(gis_lon_o) over(partition by s.locomotive_code, s.bureau_code, s.org_code, s.line_code, direction, date_format(detect_time, '%Y%m%d%H') order by s.detect_time) next_lon,
              lead(gis_lat_o) over(partition by s.locomotive_code, s.bureau_code, s.org_code, s.line_code, direction, date_format(detect_time, '%Y%m%d%H') order by s.detect_time) next_lat,
              s.detect_time
        from c3_sms s
       where s.detect_time between ':p_start_date' and ':p_end_date' - interval 1 second
         and direction is not null
         and line_code is not null
         and bureau_code is not null
      ";
    SET v_sql = replace(v_sql, ':p_start_date', date_format(p_start_date, '%Y-%m-%d %T'));
    SET v_sql = replace(v_sql, ':p_end_date', date_format(p_end_date, '%Y-%m-%d %T'));

    IF p_bureau_code IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and org_code like '", p_bureau_code, "%'");
    END IF;

    IF p_org_code IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and org_code = '", p_org_code, "%'");
    END IF;

    IF p_data_perm IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and ", p_data_perm);
    END IF;

    SET @sql = v_sql;

    PREPARE stmt FROM @sql;

    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


    DROP TABLE IF EXISTS wm_sms_v2;

    CREATE TEMPORARY TABLE wm_sms_v2
        ENGINE MEMORY
    SELECT bureau_code,
           org_code,
           locomotive_code,
           line_code,
           direction,
           date_format(detect_time, '%Y-%m-%d %H') detect_time,
           sum(gis_dist(next_lon,
                        curr_lon,
                        next_lat,
                        curr_lat))
                                                   km_num
    FROM wv_sms_v1
    GROUP BY locomotive_code,
             bureau_code,
             org_code,
             line_code,
             direction,
             date_format(detect_time, '%Y-%m-%d %H');


    DROP TABLE IF EXISTS wv_sms;

    CREATE TEMPORARY TABLE wv_sms
        ENGINE MEMORY
    SELECT bureau_code,
           org_code,
           locomotive_code,
           line_code,
           sum(km_num) km_num
    FROM wm_sms_v2
    GROUP BY bureau_code,
             org_code,
             locomotive_code,
             line_code;


    DROP TABLE IF EXISTS wv_alarm_v1;

    SET v_sql =
            "
      create temporary table wv_alarm_v1 engine memory
      select bureau_code,
             org_code,
             detect_device_code locomotive_code,
             line_code,
             severity,
             code,
             status
      FROM   alarm
      where  raised_time between :p_start_date and :p_end_date - interval 1 second
         and severity in ('一类', '二类')
         and direction is not null
         and line_code is not null
         and bureau_code is not null
      ";

    SET v_sql = replace(v_sql, ':p_start_date', p_start_date + 0);
    SET v_sql = replace(v_sql, ':p_end_date', p_end_date + 0);

    IF p_bureau_code IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and org_code like '", p_bureau_code, "%'");
    END IF;

    IF p_org_code IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and org_code = '", p_org_code, "%'");
    END IF;

    IF p_data_perm IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and ", p_data_perm);
    END IF;

    IF p_stat_codes IS NOT NULL
    THEN
        SET v_sql = concat(v_sql, " and '", p_stat_codes, "' like concat('%',status,'%')");
    END IF;

    SET @sql = v_sql;

    PREPARE stmt FROM @sql;

    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


    DROP TABLE IF EXISTS wv_alarm;

    CREATE TEMPORARY TABLE wv_alarm
        ENGINE MEMORY
    SELECT a.bureau_code,
           a.org_code,
           locomotive_code,
           a.line_code,
           count(*)                                        alarm_count,
           count(CASE WHEN p_code = 'AFBOW' THEN 1 END)    afbow_cnt,
           count(CASE WHEN p_code = 'AFBOWNET' THEN 1 END) afbownet_cnt,
           count(CASE WHEN p_code = 'AFJHCS' THEN 1 END)   afjhcs_cnt,
           count(CASE WHEN p_code = 'AFOCL' THEN 1 END)    afocl_cnt,
           count(CASE WHEN p_code = 'AFOTHOPS' THEN 1 END) afothops_cnt
    FROM wv_alarm_v1 a
             INNER JOIN wv_code c ON a.code = c.dic_code
    GROUP BY bureau_code,
             org_code,
             locomotive_code,
             line_code;


    DROP TABLE IF EXISTS wv_sms_alarm_left;

    CREATE TEMPORARY TABLE wv_sms_alarm_left
    SELECT ifnull(s.bureau_code, a.bureau_code)         bureau_code,
           ifnull(s.org_code, a.org_code)               org_code,
           ifnull(s.locomotive_code, a.locomotive_code) locomotive_code,
           ifnull(s.line_code, a.line_code)             line_code,
           km_num,
           alarm_count,
           afbow_cnt,
           afbownet_cnt,
           afjhcs_cnt,
           afocl_cnt,
           afothops_cnt
    FROM wv_sms s
             LEFT JOIN wv_alarm a
                       ON s.bureau_code = a.bureau_code
                           AND s.org_code = a.org_code
                           AND s.locomotive_code = a.locomotive_code
                           AND s.line_code = a.line_code;


    DROP TABLE IF EXISTS wv_sms_alarm_right;

    CREATE TEMPORARY TABLE wv_sms_alarm_right
        ENGINE MEMORY
    SELECT ifnull(s.bureau_code, a.bureau_code)         bureau_code,
           ifnull(s.org_code, a.org_code)               org_code,
           ifnull(s.locomotive_code, a.locomotive_code) locomotive_code,
           ifnull(s.line_code, a.line_code)             line_code,
           km_num,
           alarm_count,
           afbow_cnt,
           afbownet_cnt,
           afjhcs_cnt,
           afocl_cnt,
           afothops_cnt
    FROM wv_sms s
             RIGHT JOIN wv_alarm a
                        ON s.bureau_code = a.bureau_code
                            AND s.org_code = a.org_code
                            AND s.locomotive_code = a.locomotive_code
                            AND s.line_code = a.line_code;


    DROP TABLE IF EXISTS wv_sms_alarm;

    CREATE TEMPORARY TABLE wv_sms_alarm
        ENGINE MEMORY
    SELECT *
    FROM wv_sms_alarm_left
    UNION
    SELECT *
    FROM wv_sms_alarm_right;


    SELECT vs.bureau_code,
           cast(NULL AS CHAR(40))                bureau_name,
           vs.org_code,
           cast(NULL AS CHAR(40))                section_name,
           vs.line_code,
           cast(NULL AS CHAR(40))                line_name,
           ifnull(truncate(km_num / 1000, 3), 0) km_num,
           ifnull(alarm_count, 0)                alarm_count,
           afbow_cnt,
           afbownet_cnt,
           afjhcs_cnt,
           afocl_cnt,
           afothops_cnt
    FROM wv_sms_alarm vs;

    SELECT p_data_perm dp;
END //