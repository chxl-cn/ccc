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
    DECLARE v_exists TINYINT;

    SELECT count(*)
    INTO v_exists
    FROM loco_lrt
    WHERE locomotive_code = p_loco
      AND data_sort = p_sort;

    IF v_exists > 0 THEN
        UPDATE loco_lrt
        SET `last_time`   = p_dt,
            `id`          = p_id,
            `g_id`        = if(ifnull(p_pgs, 0) = 1, p_id, `g_id`),
            `g_last_time` = if(ifnull(p_pgs, 0) = 1, p_dt, `g_last_time`)
        WHERE locomotive_code = p_sort
          AND data_sort = p_sort
          AND last_time < p_dt;
    ELSE
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
               , if(ifnull(p_pgs, 0) = 1, p_dt, NULL));

    END IF;


END //
