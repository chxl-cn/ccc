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


    IF p_sort = 0 THEN
        INSERT INTO alarm_aux_pold
        SELECT *
        FROM alarm_aux x
        WHERE x.raised_time_aux < p_date;

        INSERT INTO alarm_img_data_pold
        SELECT *
        FROM alarm_img_data d
        WHERE d.raise_time < p_date;

        INSERT INTO nos_aa_pnew
        SELECT *
        FROM nos_aa a
        WHERE a.INPUTDATE < p_date;

        INSERT INTO nos_ac_pnew
        SELECT *
        FROM nos_ac c
        WHERE c.INPUTDATE < p_date;
    ELSE
        INSERT INTO alarm_aux_pold
        SELECT *
        FROM alarm_aux x
        WHERE x.raised_time_aux >= p_date;

        INSERT INTO alarm_img_data_pold
        SELECT *
        FROM alarm_img_data d
        WHERE d.raise_time >= p_date;

        INSERT INTO nos_aa_pnew
        SELECT *
        FROM nos_aa a
        WHERE a.INPUTDATE >= p_date;

        INSERT INTO nos_ac_pnew
        SELECT *
        FROM nos_ac c
        WHERE c.INPUTDATE >= p_date;

    END IF;



END //