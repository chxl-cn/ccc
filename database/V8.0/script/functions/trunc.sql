DELIMITER  ;
DROP FUNCTION IF EXISTS trunc;

DELIMITER //
CREATE FUNCTION trunc(d  DATETIME
                     , g VARCHAR(1)
                     ) RETURNS DATETIME
    DETERMINISTIC
BEGIN
    DECLARE r DATETIME;
    DECLARE s BIGINT;

    CASE lower(g)
        WHEN 'm' THEN SET s := second(d);
        WHEN 'h' THEN SET s := minute(d) * 60 + second(d);
        WHEN 'd' THEN SET r := cast(d AS DATE);
                      RETURN r;
        END CASE;

    SET r := date_sub(d, INTERVAL s SECOND);
    RETURN r;
END //

