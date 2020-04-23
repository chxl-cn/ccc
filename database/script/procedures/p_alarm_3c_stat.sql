DELIMITER  ;
DROP PROCEDURE IF EXISTS p_alarm_3c_stat;

DELIMITER  //
CREATE PROCEDURE p_alarm_3c_stat(IN p_bureau_code         VARCHAR(100)
                                , IN p_p_org_code         VARCHAR(100)
                                , IN p_detect_device_code VARCHAR(100)
                                , IN p_start_date         DATETIME
                                , IN p_end_date           DATETIME
                                , IN p_data_perm          TEXT
                                )
BEGIN
    DECLARE v_sql,v_where TEXT;
    DECLARE v_space VARCHAR(2) DEFAULT " ";

    SET max_heap_table_size = 17179869184;

    SET v_where = v_space;
    SET v_where = concat(v_where, char(10), if(p_bureau_code IS NOT NULL, concat("and p_org_code LIKE '", p_bureau_code, "%'"), v_space));
    SET v_where = concat(v_where, char(10), if(p_p_org_code IS NOT NULL, concat("and p_org_code = '", p_p_org_code, "'"), v_space));
    SET v_where = concat(v_where, char(10), if(p_detect_device_code IS NOT NULL, concat("and detect_device_code = '", p_detect_device_code, "'"), v_space));
    SET v_where = concat(v_where, char(10), if(p_data_perm IS NOT NULL, concat("and ", p_data_perm), v_space));


    CALL p_get_mod_sql('p_alarm_3c_stat', 1, v_sql);

    SET @sql = replace(v_sql, '<<:filter:>>', v_where);


    PREPARE stmt FROM @sql;
    SET @d1 = p_start_date;
    SET @d2 = p_end_date;

    DROP TABLE IF EXISTS t_alarm_3c_stat;
    EXECUTE stmt USING @d1,@d2;
    DEALLOCATE PREPARE stmt;

    SELECT *
    FROM t_alarm_3c_stat t
    ORDER BY detect_device_code, t.day;

    DROP TABLE IF EXISTS t_alarm_3c_stat_lvl;

    CREATE TEMPORARY TABLE t_alarm_3c_stat_lvl
        ENGINE MEMORY
    SELECT '一类'               jbmc,
           1                  ordn,
           ifnull(sum(yl), 0) cnt
    FROM t_alarm_3c_stat;

    INSERT INTO t_alarm_3c_stat_lvl
    SELECT '二类',
           2,
           ifnull(sum(el), 0)
    FROM t_alarm_3c_stat;

    INSERT INTO t_alarm_3c_stat_lvl
    SELECT '三类',
           3,
           ifnull(sum(sl), 0)
    FROM t_alarm_3c_stat;

    SELECT *
    FROM (SELECT jbmc,
                 cnt,
                 sum(cnt) OVER () gcnt,
                 ordn
          FROM t_alarm_3c_stat_lvl
         ) a
    WHERE gcnt > 0
    ORDER BY ordn;


    SELECT date_format(day, '%Y-%m-%d') rq,
           sum(count)                   cnt
    FROM t_alarm_3c_stat t1
    GROUP BY day
    ORDER BY rq;
END //

