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
    SET v_where = concat(v_where, char(10), if(p_org_code IS NOT NULL, concat("and org_code='", p_org_code, "'"), " "));

    SET @org = replace(v_sql, "<<:filter:>>", v_where);
    PREPARE stmt_org FROM @org;
    EXECUTE stmt_org;
    DEALLOCATE PREPARE stmt_org;


    DROP TABLE IF EXISTS wv_alt;

    CREATE TEMPORARY TABLE wv_alt ENGINE MEMORY
    SELECT dic_code, if(dic_code = 'AFTEMPDIFF', 'AFOCL', p_code) p_code
    FROM sys_dic d
    WHERE p_code IN ('AFBOWNET', 'AFJHCS', 'AFOCL');


    SET @sd = p_start_date;
    SET @ed = p_end_date;

    CALL p_get_mod_sql('p_pw_alrm_stat', 2, v_sql);
    SET v_where = " ";
    SET v_where = concat(v_where, char(10), if(p_bureau_code IS NOT NULL, concat("and org_code like '", p_bureau_code, "%'"), " "));
    SET v_where = concat(v_where, char(10), if(p_org_code IS NOT NULL, concat("and org_code = '", p_org_code, "'"), " "));
    SET v_where = concat(v_where, char(10), if(p_data_perm IS NOT NULL, concat("and ", p_data_perm), " "));
    SET @sms = replace(v_sql, "<<:filter:>>", v_where);

    DROP TABLE IF EXISTS wv_sms;
    PREPARE stmt_sms FROM @sms;
    EXECUTE stmt_sms USING @sd,@ed;
    DEALLOCATE PREPARE stmt_sms;


    CALL p_get_mod_sql('p_pw_alrm_stat', 3, v_sql);
    SET @alarm = replace(v_sql, "<<:filter:>>", v_where);

    DROP TABLE IF EXISTS wv_alarm;
    PREPARE stmt_alarm FROM @alarm;
    EXECUTE stmt_alarm USING @sd,@ed;
    DEALLOCATE PREPARE stmt_alarm;

    #4

    CALL p_get_mod_sql('p_pw_alrm_stat', 4, v_sql);
    SET @st1 = v_sql;
    PREPARE stmt_st1 FROM @st1;
    EXECUTE stmt_st1;
    DEALLOCATE PREPARE stmt_st1;

    #5
    CALL p_get_mod_sql('p_pw_alrm_stat', 5, v_sql);
    SET @st2 = v_sql;
    PREPARE stmt_st2 FROM @st2;
    EXECUTE stmt_st2;
    DEALLOCATE PREPARE stmt_st2;


    #6
    CALL p_get_mod_sql('p_pw_alrm_stat', 6, v_sql);
    SET @st3 = v_sql;
    PREPARE stmt_st3 FROM @st3;
    EXECUTE stmt_st3;
    DEALLOCATE PREPARE stmt_st3;

END //

