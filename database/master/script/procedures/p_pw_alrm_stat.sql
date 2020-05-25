DELIMITER  ;
DROP PROCEDURE IF EXISTS P_PW_ALRM_STAT;

DELIMITER //

CREATE PROCEDURE P_PW_ALRM_STAT
    (
        IN P_BUREAU_CODE        VARCHAR(100)
    ,   IN P_ORG_CODE           VARCHAR(100)
    ,   IN P_START_DATE         DATETIME
    ,   IN P_END_DATE           DATETIME
    ,   IN P_DATA_PERM_ORG_CODE VARCHAR(100)
    )
BEGIN
    DECLARE V_SQL,V_WHERE TEXT;

    SET max_heap_table_size = 17179869184;

    SET group_concat_max_len = 10240;

    DROP TABLE IF EXISTS WV_ORG;

    CALL p_get_mod_sql('p_pw_alrm_stat', 1, V_SQL);

    SET V_WHERE = " ";
    SET V_WHERE = concat(V_WHERE, char(10), if(P_BUREAU_CODE IS NOT NULL, concat("AND SUP_ORG_CODE='", P_BUREAU_CODE, "'"), " "));
    SET V_WHERE = concat(V_WHERE, char(10), if(P_ORG_CODE IS NOT NULL, concat("AND ORG_CODE='", P_ORG_CODE, "'"), " "));
    SET V_WHERE = concat(V_WHERE, char(10), if(P_DATA_PERM_ORG_CODE IS NOT NULL, concat("AND o.ORG_CODE like '", P_DATA_PERM_ORG_CODE, "%'"), " "));


    SET @ORG = replace(V_SQL, "<<:filter:>>", V_WHERE);
    PREPARE STMT_ORG FROM @ORG;
    EXECUTE STMT_ORG;
    DEALLOCATE PREPARE STMT_ORG;


    DROP TABLE IF EXISTS WV_ALT;

    CREATE TEMPORARY TABLE WV_ALT
        ENGINE MEMORY
        SELECT DIC_CODE, if(DIC_CODE = 'AFTEMPDIFF', 'AFOCL', P_CODE) AS P_CODE
            FROM SYS_DIC D
            WHERE P_CODE IN ( 'AFBOWNET' , 'AFJHCS' , 'AFOCL' );


    SET @SD = P_START_DATE;
    SET @ED = P_END_DATE;

    CALL p_get_mod_sql('p_pw_alrm_stat', 2, V_SQL);
    SET V_WHERE = " ";
    SET V_WHERE = concat(V_WHERE, char(10), if(P_BUREAU_CODE IS NOT NULL, concat("AND ORG_CODE LIKE '", P_BUREAU_CODE, "%'"), " "));
    SET V_WHERE = concat(V_WHERE, char(10), if(P_ORG_CODE IS NOT NULL, concat("AND ORG_CODE = '", P_ORG_CODE, "'"), " "));
    SET @SMS = replace(V_SQL, "<<:filter:>>", V_WHERE);

    DROP TABLE IF EXISTS WV_SMS;
    PREPARE STMT_SMS FROM @SMS;
    EXECUTE STMT_SMS USING @SD,@ED;
    DEALLOCATE PREPARE STMT_SMS;


    SET V_WHERE = concat(V_WHERE, char(10), if(P_BUREAU_CODE IS NOT NULL, concat("AND ORG_CODE LIKE '", P_BUREAU_CODE, "%'"), " "));
    SET V_WHERE = concat(V_WHERE, char(10), if(P_ORG_CODE IS NOT NULL, concat("AND ORG_CODE = '", P_ORG_CODE, "'"), " "));
    CALL p_get_mod_sql('p_pw_alrm_stat', 3, V_SQL);
    SET @ALARM = replace(V_SQL, "<<:filter:>>", V_WHERE);

    DROP TABLE IF EXISTS WV_ALARM;
    PREPARE STMT_ALARM FROM @ALARM;
    EXECUTE STMT_ALARM USING @SD,@ED;
    DEALLOCATE PREPARE STMT_ALARM;

    #4
    DROP TABLE IF EXISTS wv_sms_ds;
    DROP TABLE IF EXISTS wv_sms_ln;

    CREATE TABLE wv_sms_ds
        ENGINE MEMORY
        SELECT locomotive_code, count(*) AS rtds
            FROM (
                 SELECT locomotive_code, date(detect_time) AS rt
                     FROM wv_sms
                     GROUP BY locomotive_code
                            , date(detect_time)
                 ) tt
            GROUP BY locomotive_code;

    CREATE TABLE wv_sms_ln
        #ENGINE MEMORY
        SELECT locomotive_code, group_concat(line_code) AS line_code
            FROM (
                 SELECT locomotive_code, line_code AS line_code
                     FROM wv_sms
                     GROUP BY locomotive_code
                            , line_code
                 ) tt
            GROUP BY locomotive_code;


    CALL p_get_mod_sql('p_pw_alrm_stat', 4, V_SQL);
    SET @ST1 = V_SQL;
    PREPARE STMT_ST1 FROM @ST1;
    EXECUTE STMT_ST1;
    DEALLOCATE PREPARE STMT_ST1;

    #5
    CALL p_get_mod_sql('p_pw_alrm_stat', 5, V_SQL);
    SET @ST2 = V_SQL;
    PREPARE STMT_ST2 FROM @ST2;
    EXECUTE STMT_ST2;
    DEALLOCATE PREPARE STMT_ST2;


    #6
    CALL p_get_mod_sql('p_pw_alrm_stat', 6, V_SQL);
    SET @ST3 = V_SQL;
    PREPARE STMT_ST3 FROM @ST3;
    EXECUTE STMT_ST3;
    DEALLOCATE PREPARE STMT_ST3;

END //

