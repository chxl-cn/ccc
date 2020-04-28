DELIMITER ;
DROP PROCEDURE IF EXISTS p_load_data_proc;


/*
 p_sort :0 历史，1 增量
 */
DELIMITER  //
CREATE PROCEDURE p_load_data_proc(p_date  DATETIME
                                 , p_sort TINYINT
                                 )
BEGIN
    DECLARE v_aux_sql,v_img_sql,v_aa_sql,v_ac_sql TEXT;
    DECLARE v_opt,v_dt VARCHAR(20);
    SET v_opt = if(p_sort = 1, ">=", "<");
    SET v_dt = p_date + 0;


    SET v_aux_sql = concat("INSERT INTO alarm_aux_pold SELECT * FROM alarm_aux x WHERE x.raised_time_aux  ", v_opt, v_dt);
    SET v_img_sql = concat("INSERT INTO alarm_img_data_pold  SELECT * FROM alarm_img_data d WHERE d.raise_time  ", v_opt, v_dt);
    SET v_aa_sql = concat("INSERT INTO nos_aa_pnew  SELECT * FROM nos_aa a WHERE a.INPUTDATE  ", v_opt, v_dt);
    SET v_ac_sql = concat("INSERT INTO nos_ac_pnew SELECT * FROM nos_ac c WHERE c.INPUTDATE  ", v_opt, v_dt);

    SET @stmt = v_aux_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @stmt = v_img_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @stmt = v_aa_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @stmt = v_ac_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


END //