DELIMITER ;
DROP PROCEDURE IF EXISTS p_gen_parts_schd;

DELIMITER //
CREATE PROCEDURE p_gen_parts_schd(
                                 )
BEGIN
    CALL p_gen_parts('alarm');
    CALL p_gen_parts('alarm_aux');
    CALL p_gen_parts('alarm_others');
    CALL p_gen_parts('nos_aa');

    CALL p_gen_parts('c3_sms');
    CALL p_gen_parts('c3_sms_monitor');
    CALL p_gen_parts('nos_ac');

    CALL p_gen_parts('stat_alarm_ex');
    CALL p_gen_parts('stat_sms_ex');


END //

