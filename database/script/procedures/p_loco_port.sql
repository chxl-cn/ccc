DELIMITER  ;
DROP PROCEDURE IF EXISTS p_loco_port;

DELIMITER  //
CREATE PROCEDURE p_loco_port(p_loco       VARCHAR(40)
                            , p_gno       VARCHAR(2)
                            , OUT p_port1 VARCHAR(5)
                            , OUT p_port2 VARCHAR(5)
                            )
BEGIN
    SELECT regexp_substr(p, '[[:digit:]]+', 1, 1), regexp_substr(p, '[[:digit:]]+', 1, 2)
    INTO p_port1,p_port2
    FROM (
             SELECT regexp_substr(l.device_bow_relations, '[[:digit:]]+,[[:digit:]]+', 1, p_gno) p
             FROM locomotive l
             WHERE l.locomotive_code = p_loco
         ) t;
END //




