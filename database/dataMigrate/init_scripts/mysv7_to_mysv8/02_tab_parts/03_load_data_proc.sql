
DELIMITER ;
drop PROCEDURE IF EXISTS p_load_data_proc;


/*
 p_sort :0 历史，1 增量
 */
DELIMITER  //
create PROCEDURE p_load_data_proc(p_date DATETIME,p_sort TINYINT)
BEGIN

END //