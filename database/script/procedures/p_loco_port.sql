DELIMITER  ;
DROP PROCEDURE IF EXISTS p_loco_port;

DELIMITER  //
CREATE PROCEDURE p_loco_port(
                            )
BEGIN
    DROP TABLE IF EXISTS wv_loco_ports;
    CREATE TEMPORARY TABLE wv_loco_ports
        ENGINE MEMORY
    SELECT locomotive,
           regexp_substr(p1, '[[:digit:]]+', 1, 1) g1p1,
           regexp_substr(p1, '[[:digit:]]+', 1, 2) g1p2,
           regexp_substr(p2, '[[:digit:]]+', 1, 1) g2p1,
           regexp_substr(p2, '[[:digit:]]+', 1, 2) g2p2
    FROM (
             SELECT locomotive,
                    regexp_substr(l.device_bow_relations, '[[:digit:]]+,[[:digit:]]+', 1, 1) p1,
                    regexp_substr(l.device_bow_relations, '[[:digit:]]+,[[:digit:]]+', 1, 2) p2
             FROM locomotive l
         ) t;
    alter table wv_loco_ports add PRIMARY KEY (locomotive) ;
    select * from wv_loco_ports ;
END //




