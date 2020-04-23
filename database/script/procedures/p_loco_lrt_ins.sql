DELIMITER  ;
DROP PROCEDURE IF EXISTS p_loco_lrt_ins;

DELIMITER  //
CREATE PROCEDURE p_loco_lrt_ins(p_loco  VARCHAR(40)
                               , p_sort TINYINT
                               , p_id   VARCHAR(60)
                               , p_dt   DATETIME
                               , p_pgs  TINYINT
                               )
BEGIN
    INSERT INTO loco_lrt( locomotive_code
                        , data_sort
                        , last_time
                        , id
                        , g_id
                        , g_last_time)
    VALUES ( p_loco
           , p_sort
           , p_dt
           , p_id
           , if(ifnull(p_pgs, 0) = 1, p_id, NULL)
           , if(ifnull(p_pgs, 0) = 1, p_dt, NULL))
    ON DUPLICATE KEY
        UPDATE `last_time`   = if(`last_time` < p_dt, p_dt, `last_time`),
               `id`          = if(`last_time` < p_dt, p_id, `id`),
               `g_id`        = if(`last_time` < p_dt, if(ifnull(p_pgs, 0) = 1, p_id, `g_id`), `g_id`),
               `g_last_time` = if(`last_time` < p_dt, if(ifnull(p_pgs, 0) = 1, p_dt, `g_last_time`), `g_last_time`);


END //
