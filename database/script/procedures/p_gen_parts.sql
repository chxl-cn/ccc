  DELIMITER  ;
DROP PROCEDURE IF EXISTS p_gen_parts;

DELIMITER  //
CREATE PROCEDURE p_gen_parts(IN p_tbn VARCHAR(40)
                            )
BEGIN
    DECLARE v_mx_date,v_up_date DATETIME;
    DECLARE v_sql,v_psql,v_pn,v_pv,v_pd TEXT;

    SET v_up_date = CURRENT_DATE + INTERVAL 1 MONTH;
    SET v_psql = CONCAT("alter table ", p_tbn, " add partition(partition p_:pn values less than (':pv'))");

    SELECT partition_description
    INTO v_pd
    FROM information_schema.partitions p
    WHERE table_name = p_tbn
      AND table_schema = DATABASE()
      AND partition_name != 'p_mx'
    ORDER BY p.partition_ordinal_position DESC
    LIMIT 1;

    SET v_mx_date = replace(v_pd, "'", "");

    WHILE v_mx_date <= v_up_date
    DO
        SET v_mx_date = v_mx_date + INTERVAL 1 DAY;
        SET v_pn = date_format(v_mx_date, '%Y%m%d');
        SET v_pv = date_format(v_mx_date, '%Y-%m-%d');
        SET v_sql = replace(v_psql, ':pn', v_pn);
        SET v_sql = replace(v_sql, ':pv', v_pv);

        SET @sql = v_sql;
        PREPARE stat_partition FROM @sql;
        EXECUTE stat_partition;
        DEALLOCATE PREPARE stat_partition;
    END WHILE;

END //