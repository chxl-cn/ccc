DELIMITER ;
DROP EVENT IF EXISTS event_tab_parts;

DELIMITER //
CREATE EVENT event_tab_parts
    ON SCHEDULE
        EVERY '1' DAY
    ON COMPLETION PRESERVE
    ENABLE
    COMMENT '每天执行分区'
    DO
    BEGIN
        CALL p_gen_parts_schd() ;
    END//
