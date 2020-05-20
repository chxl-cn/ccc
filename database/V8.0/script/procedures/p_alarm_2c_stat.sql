DELIMITER  ;
DROP PROCEDURE IF EXISTS p_alarm_2c_stat;

DELIMITER  //

CREATE PROCEDURE p_alarm_2c_stat(IN p_sraised_time        DATETIME
                                , IN p_eraised_time       DATETIME
                                , IN p_bureau_code        VARCHAR(100)
                                , IN p_power_section_code VARCHAR(100)
                                , IN p_p_org_code         VARCHAR(100)
                                , IN p_workshop_code      VARCHAR(100)
                                , IN p_org_code_          VARCHAR(100)
                                , IN p_line_code          VARCHAR(100)
                                , IN p_pole_number        VARCHAR(100)
                                , IN p_direction          VARCHAR(100)
                                , IN p_skm_mark           DECIMAL
                                , IN p_ekm_mark           DECIMAL
                                , IN p_status             VARCHAR(100)
                                , IN p_code               VARCHAR(100)
                                , IN p_user_code          VARCHAR(100)
                                )
BEGIN

    DROP TABLE IF EXISTS t_alarm_2c_stat;
    CREATE TEMPORARY TABLE t_alarm_2c_stat
    (
        img100         VARCHAR(200),
        img500         VARCHAR(200),
        line_name      VARCHAR(50),
        severity       VARCHAR(4),
        position_name  VARCHAR(50),
        raised_time    VARCHAR(10),
        km_mark        NUMERIC(16),
        pole_number    VARCHAR(10),
        summary        VARCHAR(50),
        direction      VARCHAR(100),
        fault_frame_no NUMERIC(16),
        prev_frame_num NUMERIC(16),
        next_frame_num NUMERIC(16),
        detail         VARCHAR(512),
        svalue6        VARCHAR(128),
        svalue8        VARCHAR(2048),
        dir_path       VARCHAR(256)
    ) ENGINE MEMORY;


    INSERT INTO t_alarm_2c_stat
    SELECT '',
           '',
           line_name,
           CASE
               WHEN t.severity = '一类' THEN
                   '严重'
               WHEN t.severity = '二类' THEN
                   '警告'
               WHEN t.severity = '三类' THEN
                   '普通'
               END                                   severity,
           position_name,
           date_format(t.raised_time, '%Y.%m.%d') AS raised_time,
           km_mark,
           pole_number,
           code_name                                 summary,
           direction,
           nvalue1                                   fault_frame_no,
           nvalue2                                   prev_frame_num,
           nvalue3                                   next_frame_num,
           detail,
           svalue6,
           svalue8,
           dir_path
    FROM alarm t
    WHERE category_code = '2C'
      AND data_type = 'FAULT'
      AND raised_time >= p_sraised_time
      AND raised_time <= p_eraised_time
      AND (p_bureau_code IS NULL OR bureau_code = p_bureau_code)
      AND (p_power_section_code IS NULL OR power_section_code = p_power_section_code)
      AND (p_p_org_code IS NULL OR p_org_code = p_p_org_code)
      AND (p_workshop_code IS NULL OR workshop_code = p_workshop_code)
      AND (p_org_code_ IS NULL OR org_code = p_org_code_)
      AND (p_line_code IS NULL OR line_code = p_line_code)
      AND (p_pole_number IS NULL OR pole_number = p_pole_number)
      AND (p_direction IS NULL OR direction = p_direction)
      AND (p_skm_mark IS NULL OR km_mark >= p_skm_mark)
      AND (p_ekm_mark IS NULL OR km_mark <= p_ekm_mark)
      AND (p_status IS NULL OR instr(p_status, status) > 0)
      AND (p_code IS NULL OR t.code_name = p_code);


    SELECT img100,
           img500,
           line_name,
           severity,
           position_name,
           raised_time,
           truncate(km_mark / 1000,0)                                       km_mark_org,
           fault_frame_no,
           prev_frame_num,
           next_frame_num,
           concat('K', truncate(km_mark / 1000,0), '+', mod(km_mark, 1000)) km_mark,
           pole_number,
           summary,
           direction,
           detail,
           svalue6,
           svalue8,
           dir_path
    FROM t_alarm_2c_stat;


    SELECT summary,
           count(*)                                                            count,
           concat(truncate(count(*) * 100 / sum(COUNT(*)) OVER (), 2), '%') AS percent
    FROM t_alarm_2c_stat
    GROUP BY summary
    ORDER BY 2 DESC;


    SELECT severity,
           count(*)                                                         count,
           concat(truncate(count(*) * 100 / sum(COUNT(*)) OVER (), 2), '%') percent
    FROM t_alarm_2c_stat
    GROUP BY severity;


END //

