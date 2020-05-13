DELIMITER  ;
DROP PROCEDURE IF EXISTS p_parse_smsmv;

DELIMITER //
CREATE PROCEDURE p_parse_smsmv(
                              )
BEGIN
    DECLARE v_id VARCHAR(60);
    DECLARE v_device_version VARCHAR(60);
    DECLARE v_is_con_ir VARCHAR(60);
    DECLARE v_is_rec_ir VARCHAR(60);
    DECLARE v_is_con_ov VARCHAR(60);
    DECLARE v_is_rec_ov VARCHAR(60);
    DECLARE v_is_con_vi VARCHAR(60);
    DECLARE v_is_rec_vi VARCHAR(60);
    DECLARE v_is_con_fz VARCHAR(60);
    DECLARE v_is_rec_fz VARCHAR(60);
    DECLARE v_device_group_no VARCHAR(60);
    DECLARE v_line_height_1 VARCHAR(60);
    DECLARE v_line_height_2 VARCHAR(60);
    DECLARE v_pulling_value_1 VARCHAR(60);
    DECLARE v_pulling_value_2 VARCHAR(60);
    DECLARE v_irv_temp_1 VARCHAR(60);
    DECLARE v_env_temp_1 VARCHAR(60);
    DECLARE v_irv_temp_2 VARCHAR(60);
    DECLARE v_env_temp_2 VARCHAR(60);
    DECLARE v_bow_updown_status VARCHAR(60);
    DECLARE v_temp_sensor_status VARCHAR(60);
    DECLARE v_extra_info VARCHAR(600);
    DECLARE v_high_1 INT;
    DECLARE v_high_2 INT;
    DECLARE v_pull_1 INT;
    DECLARE v_pull_2 INT;
    DECLARE v_portn1 VARCHAR(20);
    DECLARE v_portn2 VARCHAR(20);
    DECLARE v_dev_bow VARCHAR(200);
    DECLARE v_is_mport BOOLEAN;
    DECLARE v_is_gport BOOLEAN;
    DECLARE v_loco_code VARCHAR(40);
    DECLARE _irv_temp VARCHAR(15);
    DECLARE _env_temp VARCHAR(15);
    DECLARE _port_number VARCHAR(10);
    DECLARE _temp_sensor_status VARCHAR(6);
    DECLARE _is_con_ir VARCHAR(60);
    DECLARE _is_rec_ir VARCHAR(60);
    DECLARE _is_con_vi VARCHAR(60);
    DECLARE _is_rec_vi VARCHAR(60);
    DECLARE _is_con_ov VARCHAR(60);
    DECLARE _is_rec_ov VARCHAR(60);
    DECLARE _is_con_fz VARCHAR(60);
    DECLARE _is_rec_fz VARCHAR(60);
    DECLARE _line_height VARCHAR(60);
    DECLARE _pulling_value VARCHAR(60);
    DECLARE _line_height_x VARCHAR(60);
    DECLARE _pulling_value_x VARCHAR(60);
    DECLARE _bow_updown_status VARCHAR(60);
    DECLARE _socket1 VARCHAR(6);
    DECLARE _socket2 VARCHAR(6);
    DECLARE _cpu1 INT;
    DECLARE _cpu2 INT;
    DECLARE v_done BOOLEAN;
    #DECLARE v_loco VARCHAR(40);


    DECLARE cv_mon CURSOR FOR SELECT * FROM wv_mon;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

    DROP TABLE IF EXISTS wv_loco_ports;
    CREATE TEMPORARY TABLE wv_loco_ports
        ENGINE MEMORY
    SELECT locomotive_code,
           regexp_substr(p1, '[[:digit:]]+', 1, 1) g1p1,
           regexp_substr(p1, '[[:digit:]]+', 1, 2) g1p2,
           regexp_substr(p2, '[[:digit:]]+', 1, 1) g2p1,
           regexp_substr(p2, '[[:digit:]]+', 1, 2) g2p2
    FROM (
             SELECT locomotive_code,
                    regexp_substr(l.device_bow_relations, '[[:digit:]]+,[[:digit:]]+', 1, 1) p1,
                    regexp_substr(l.device_bow_relations, '[[:digit:]]+,[[:digit:]]+', 1, 2) p2
             FROM locomotive l
         ) t;

    ALTER TABLE wv_loco_ports
        ADD PRIMARY KEY (locomotive_code);

    OPEN cv_mon;
    SET v_done := FALSE;
    iterate_mon:
    LOOP
        FETCH cv_mon INTO
            v_id,
            v_irv_temp_1,
            v_irv_temp_2,
            v_env_temp_1,
            v_env_temp_2,
            v_temp_sensor_status,
            v_is_con_ir,
            v_is_rec_ir,
            v_is_con_vi,
            v_is_rec_vi,
            v_is_con_ov,
            v_is_rec_ov,
            v_is_con_fz,
            v_is_rec_fz,
            v_line_height_1,
            v_line_height_2,
            v_pulling_value_1,
            v_pulling_value_2,
            v_device_version,
            v_device_group_no,
            v_bow_updown_status,
            v_extra_info,
            v_loco_code;
        IF v_done THEN
            LEAVE iterate_mon;
        END IF;

        SET v_is_mport := NOT regexp_like(v_device_version, 'PS(3|3B|4|4B)');

        mport:
        BEGIN
            SET v_is_gport = NOT (v_is_mport AND v_device_version = 'PS5');

            SET v_dev_bow = NULL;

            IF NOT v_is_gport
            THEN
                SET v_portn1 := 'A端';
                SET v_portn2 := 'B端';
            ELSE
                lb_getport:
                BEGIN
                    SET v_portn1 := '4';
                    SET v_portn2 := '6';

                    IF v_device_group_no IS NULL OR NOT exists(SELECT NULL FROM wv_loco_ports WHERE locomotive_code = v_loco_code) THEN
                        LEAVE lb_getport ;
                    END IF;

                    IF v_device_group_no = 1 THEN
                        SELECT g1p1, g1p2
                        INTO v_portn1,v_portn2
                        FROM wv_loco_ports
                        WHERE locomotive_code = v_loco_code;
                    ELSE
                        SELECT g2p1, g2p2
                        INTO v_portn1,v_portn2
                        FROM wv_loco_ports
                        WHERE locomotive_code = v_loco_code;
                    END IF;
                END;

            END IF;

            SET v_high_1 := NULL;
            SET v_high_2 := NULL;
            SET v_pull_1 := NULL;
            SET v_pull_2 := NULL;

            IF v_bow_updown_status = '10' OR v_bow_updown_status = '01'
            THEN
                SET v_high_1 := ifnull(nullif(v_line_height_1, -1000), v_line_height_2);
                SET v_pull_1 := ifnull(nullif(v_pulling_value_1, -1000), v_pulling_value_2);
            ELSEIF v_bow_updown_status = '11'
            THEN
                SET v_high_1 := v_line_height_1;
                SET v_pull_1 := v_pulling_value_1;
                SET v_high_2 := v_line_height_2;
                SET v_pull_2 := v_pulling_value_2;
            END IF;

            SET _line_height_x = ifnull(ifnull(nullif(v_line_height_1, -1000), v_line_height_2), -1000);
            SET _pulling_value_x = ifnull(ifnull(nullif(v_pulling_value_1, -1000), v_pulling_value_2), -1000);
            SET _port_number = v_portn1;
            SET _irv_temp = ifnull(v_irv_temp_1, -1000);
            SET _env_temp = ifnull(v_env_temp_1, -1000);
            SET _line_height = ifnull(v_high_1, -1000);
            SET _pulling_value = ifnull(v_pull_1, -1000);
            SET _is_con_ir = if(v_is_con_ir, if(v_is_con_ir & 2, '正常', '异常'), NULL);
            SET _is_rec_ir = if(v_is_rec_ir, if(v_is_rec_ir & 2, '正常', '异常'), NULL);
            SET _is_con_vi = if(v_is_con_vi, if(v_is_con_vi & 2, '正常', '异常'), NULL);
            SET _is_rec_vi = if(v_is_rec_vi, if(v_is_rec_vi & 2, '正常', '异常'), NULL);
            SET _is_con_ov = if(v_is_con_ov, if(v_is_con_ov & 2, '正常', '异常'), NULL);
            SET _is_rec_ov = if(v_is_rec_ov, if(v_is_rec_ov & 2, '正常', '异常'), NULL);
            SET _is_con_fz = if(v_is_con_fz, if(v_is_con_fz & 2, '正常', '异常'), NULL);
            SET _is_rec_fz = if(v_is_rec_fz AND v_is_gport, if(v_is_rec_fz & 2, '正常', '异常'), NULL);
            SET _bow_updown_status = if(v_bow_updown_status & 2, '升', NULL);
            SET _temp_sensor_status = if(v_temp_sensor_status & 2, '升', NULL);
            SET _socket1 = regexp_substr(regexp_substr(v_extra_info, 'SocketStatus[^,]+'), '[[:digit:]]+', 1, 1);
            SET _socket2 = regexp_substr(regexp_substr(v_extra_info, 'SocketStatus[^,]+'), '[[:digit:]]+', 1, 2);
            SET _cpu1 = regexp_substr(regexp_substr(v_extra_info, 'CpuUsingRate[^,]+'), '[[:digit:]]+', 1, 1);
            SET _cpu2 = regexp_substr(regexp_substr(v_extra_info, 'CpuUsingRate[^,]+'), '[[:digit:]]+', 1, 2);

            INSERT INTO wv_mvalue( id
                                 , irv_temp
                                 , env_temp
                                 , port_number
                                 , temp_sensor_status,
                                   is_con_ir
                                 , is_rec_ir
                                 , is_con_vi
                                 , is_rec_vi
                                 , is_con_ov
                                 , is_rec_ov
                                 , is_con_fz
                                 , is_rec_fz
                                 , line_height
                                 , pulling_value
                                 , line_height_x
                                 , pulling_value_x
                                 , bow_updown_status
                                 , socket1
                                 , socket2
                                 , cpu1
                                 , cpu2,
                                   grp)
            VALUES (v_id,
                    _irv_temp,
                    _env_temp,
                    _port_number,
                    _temp_sensor_status,
                    _is_con_ir,
                    _is_rec_ir,
                    _is_con_vi,
                    _is_rec_vi,
                    _is_con_ov,
                    _is_rec_ov,
                    _is_con_fz,
                    _is_rec_fz,
                    _line_height,
                    _pulling_value,
                    _line_height_x,
                    _pulling_value_x,
                    _bow_updown_status,
                    _socket1,
                    _socket2,
                    _cpu1,
                    _cpu2,
                    v_device_group_no);


            SET _port_number = v_portn2;
            SET _irv_temp = ifnull(v_irv_temp_2, -1000);
            SET _env_temp = ifnull(v_env_temp_2, -1000);
            SET _line_height = ifnull(v_high_2, -1000);
            SET _pulling_value = ifnull(v_pull_2, -1000);
            SET _is_con_ir = if(v_is_con_ir, IF(v_is_con_ir & 1, '正常', '异常'), NULL);
            SET _is_rec_ir = if(v_is_rec_ir, IF(v_is_rec_ir & 1, '正常', '异常'), NULL);
            SET _is_con_vi = if(v_is_con_vi, IF(v_is_con_vi & 1, '正常', '异常'), NULL);
            SET _is_rec_vi = if(v_is_rec_vi, IF(v_is_rec_vi & 1, '正常', '异常'), NULL);
            SET _is_con_ov = if(v_is_con_ov, IF(v_is_con_ov & 1, '正常', '异常'), NULL);
            SET _is_rec_ov = if(v_is_rec_ov, IF(v_is_rec_ov & 1, '正常', '异常'), NULL);
            SET _is_con_fz = if(v_is_con_fz, IF(v_is_con_fz & 1, '正常', '异常'), NULL);
            SET _is_rec_fz = if(v_is_rec_fz AND v_is_gport, IF(v_is_rec_fz & 1, '正常', '异常'), NULL);
            SET _bow_updown_status = IF(v_bow_updown_status & 1, '升', NULL);
            SET _temp_sensor_status = IF(v_temp_sensor_status & 1, '升', NULL);
            SET _socket1 = regexp_substr(regexp_substr(v_extra_info, 'SocketStatus[^,]+'), '[[:digit:]]+', 1, 3);
            SET _socket2 = regexp_substr(regexp_substr(v_extra_info, 'SocketStatus[^,]+'), '[[:digit:]]+', 1, 4);
            SET _cpu1 = regexp_substr(regexp_substr(v_extra_info, 'CpuUsingRate[^,]+'), '[[:digit:]]+', 1, 3);
            SET _cpu2 = regexp_substr(regexp_substr(v_extra_info, 'CpuUsingRate[^,]+'), '[[:digit:]]+', 1, 4);


            INSERT INTO wv_mvalue( id
                                 , irv_temp
                                 , env_temp
                                 , port_number
                                 , temp_sensor_status,
                                   is_con_ir
                                 , is_rec_ir
                                 , is_con_vi
                                 , is_rec_vi
                                 , is_con_ov
                                 , is_rec_ov
                                 , is_con_fz
                                 , is_rec_fz
                                 , line_height
                                 , pulling_value
                                 , line_height_x
                                 , pulling_value_x
                                 , bow_updown_status
                                 , socket1
                                 , socket2
                                 , cpu1
                                 , cpu2, grp)
            VALUES (v_id,
                    _irv_temp,
                    _env_temp,
                    _port_number,
                    _temp_sensor_status,
                    _is_con_ir,
                    _is_rec_ir,
                    _is_con_vi,
                    _is_rec_vi,
                    _is_con_ov,
                    _is_rec_ov,
                    _is_con_fz,
                    _is_rec_fz,
                    _line_height,
                    _pulling_value,
                    _line_height_x,
                    _pulling_value_x,
                    _bow_updown_status,
                    _socket1,
                    _socket2,
                    _cpu1,
                    _cpu2,
                    v_device_group_no);
            ITERATE iterate_mon;
        END;

        sport:
        BEGIN

            SET _port_number = if(v_bow_updown_status & 2, 'A端', 'B端');
            SET _irv_temp = ifnull(if(v_is_con_ir & 2, v_irv_temp_1, v_irv_temp_2), -1000);
            SET _env_temp = ifnull(if(v_temp_sensor_status & 2, v_env_temp_1, v_env_temp_2), -1000);
            SET _line_height = ifnull(v_line_height_1, -1000);
            SET _pulling_value = ifnull(v_pulling_value_1, -1000);
            SET _line_height_x = ifnull(v_line_height_1, -1000);
            SET _pulling_value_x = ifnull(v_pulling_value_1, -1000);
            SET _is_con_ir = if(v_is_con_ir, IF(v_is_con_ir, '正常', '异常'), NULL);
            SET _is_rec_ir = if(v_is_rec_ir, IF(v_is_rec_ir, '正常', '异常'), NULL);
            SET _is_con_vi = if(v_is_con_vi, IF(v_is_con_vi, '正常', '异常'), NULL);
            SET _is_rec_vi = if(v_is_rec_vi, IF(v_is_rec_vi, '正常', '异常'), NULL);
            SET _is_con_ov = if(regexp_like(v_device_version, 'PS(3|3B)'), NULL, if(v_is_rec_vi, IF(v_is_rec_vi, '正常', '异常'), NULL));
            SET _is_rec_ov = if(regexp_like(v_device_version, 'PS(3|3B)'), NULL, if(v_is_rec_vi, IF(v_is_rec_vi, '正常', '异常'), NULL));
            SET _temp_sensor_status = IF(v_temp_sensor_status, '正常', NULL);
            SET _bow_updown_status = IF(v_bow_updown_status, '升', NULL);
            SET _temp_sensor_status = IF(v_temp_sensor_status, '正常', NULL);
            INSERT INTO wv_mvalue( id
                                 , irv_temp
                                 , env_temp
                                 , port_number
                                 , temp_sensor_status
                                 , is_con_ir
                                 , is_rec_ir
                                 , is_con_vi
                                 , is_rec_vi
                                 , is_con_ov
                                 , is_rec_ov
                                 , is_con_fz
                                 , is_rec_fz
                                 , line_height
                                 , pulling_value
                                 , line_height_x
                                 , pulling_value_x
                                 , bow_updown_status
                                 , socket1
                                 , socket2
                                 , cpu1
                                 , cpu2)
            VALUES (v_id,
                    _irv_temp,
                    _env_temp,
                    _port_number,
                    _temp_sensor_status,
                    _is_con_ir,
                    _is_rec_ir,
                    _is_con_vi,
                    _is_rec_vi,
                    _is_con_ov,
                    _is_rec_ov,
                    _is_con_fz,
                    _is_rec_fz,
                    _line_height,
                    _pulling_value,
                    _line_height_x,
                    _pulling_value_x,
                    _bow_updown_status,
                    _socket1,
                    _socket2,
                    _cpu1,
                    _cpu2);

        END;
    END LOOP;

END //