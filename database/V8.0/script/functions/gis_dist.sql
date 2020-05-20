delimiter ;
drop function if exists gis_dist;

delimiter //
create function gis_dist(p_start_gislon decimal
                        , p_end_gislon decimal
                        , p_start_gislat decimal
                        , p_end_gislat decimal)
    returns decimal
    deterministic
BEGIN
    DECLARE s_radlon DECIMAL;
    DECLARE e_radlon DECIMAL;
    DECLARE s_radlat DECIMAL;
    DECLARE e_radlat DECIMAL;
    DECLARE angle DECIMAL;
    DECLARE v_any_gis_null boolean;
    DECLARE v_dist DECIMAL;
    DECLARE v_angle_in DECIMAL;

    DECLARE v_PI DECIMAL DEFAULT 3.1415926535;
    DECLARE earth_radius numeric(15, 6) DEFAULT 6378.1370;

    SET v_dist := NULL;

    SET v_any_gis_null := p_start_gislon IS NULL;
    SET v_any_gis_null := v_any_gis_null OR p_end_gislon IS NULL;
    SET v_any_gis_null := v_any_gis_null OR p_start_gislat IS NULL;
    SET v_any_gis_null := v_any_gis_null OR p_end_gislat IS NULL;

    IF v_any_gis_null THEN
        RETURN v_dist;
    END IF;


    SET s_radlon := p_start_gislon * v_PI / 180.0;
    SET e_radlon := p_end_gislon * v_PI / 180.0;
    SET s_radlat := p_start_gislat * v_PI / 180.0;
    SET e_radlat := p_end_gislat * v_PI / 180.0;
    SET v_angle_in := sin(s_radlat) * sin(e_radlat) + cos(s_radlat) * cos(e_radlat) * cos(s_radlon - e_radlon);

    IF v_angle_in < -1 OR v_angle_in > 1
    THEN
        SET v_angle_in := CASE WHEN v_angle_in < -1 THEN -1 ELSE 1 END;
    END IF;

    SET angle := acos(v_angle_in);

    SET v_dist := truncate((earth_radius * angle * 1000), 2);


    RETURN v_dist;
END //