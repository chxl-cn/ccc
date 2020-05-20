DELIMITER ;
DROP PROCEDURE IF EXISTS p_alarm_4c_stat;

DELIMITER  //
CREATE PROCEDURE p_alarm_4c_stat(IN p_sraised_time        DATETIME
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


    DROP TABLE IF EXISTS t_alarm_4c_stat;
    CREATE TEMPORARY TABLE t_alarm_4c_stat
    (
        line_name     VARCHAR(50),
        km_mark       NUMERIC,
        pole_number   VARCHAR(10),
        summary       VARCHAR(50),
        direction     VARCHAR(100),
        position_name VARCHAR(50),
        brg_tun_name  VARCHAR(50),
        lcz           NUMERIC,
        dgz           NUMERIC,
        wy            NUMERIC,
        gis_x         NUMERIC,
        gis_y         NUMERIC,
        detail        VARCHAR(512),
        svalue1       VARCHAR(2048),
        nvalue4       NUMERIC(16),
        svalue6       VARCHAR(128),
        svalue7       VARCHAR(2048),
        dir_path      VARCHAR(256),
        imga1         VARCHAR(256),
        imga2         VARCHAR(256),
        imga3         VARCHAR(256),
        imga4         VARCHAR(256),
        imga5         VARCHAR(256),
        imga6         VARCHAR(256),
        severity      VARCHAR(4),
        raised_time   VARCHAR(10)
    ) ENGINE MEMORY;

    INSERT INTO t_alarm_4c_stat
    SELECT line_name,
           km_mark,
           pole_number,
           code_name                              summary,
           direction,
           position_name,
           brg_tun_name,
           nvalue2                                lcz,
           nvalue1                                dgz,
           nvalue3                                wy,
           gis_x,
           gis_y,
           detail,
           svalue1,
           nvalue4,
           svalue6,
           t.svalue7,
           t.dir_path,
           '',
           '',
           '',
           '',
           '',
           '',
           CASE
               WHEN t.severity = '一类' THEN
                   '严重'
               WHEN t.severity = '二类' THEN
                   '警告'
               WHEN t.severity = '三类' THEN
                   '普通'
               END                                severity,
           date_format(t.raised_time, '%Y.%m.%d') raised_time
    FROM alarm t
    WHERE category_code = '4C'
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


    SELECT line_name,
           km_mark                                                           km_mark_org,
           concat('K', truncate(km_mark / 1000, 0), '+', mod(km_mark, 1000)) km_mark,
           pole_number,
           summary,
           direction,
           position_name,
           brg_tun_name,
           lcz,
           dgz,
           wy,
           gis_x,
           gis_y,
           detail,
           svalue1                                                           play_dir_name,
           nvalue4                                                           fault_frame_no,
           svalue6,
           svalue7,
           imga1,
           imga2,
           imga3,
           imga4,
           imga5,
           imga6,
           dir_path,
           severity,
           raised_time
    FROM t_alarm_4c_stat;


    SELECT summary,
           count(summary)                                                               count,
           concat(truncate(count(summary) * 100 / sum(count(summary)) OVER (), 2), '%') percent
    FROM t_alarm_4c_stat t
    GROUP BY summary;


    SELECT severity,
           count(severity)                                                     count,
           concat(truncate(count(*) * 100 / sum(count(*)) OVER (), 2), '%') AS percent
    FROM t_alarm_4c_stat t
    GROUP BY severity;

END //

