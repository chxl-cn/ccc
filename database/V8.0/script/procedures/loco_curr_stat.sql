delimiter ;
drop procedure if exists loco_curr_stat;

delimiter //
create procedure loco_curr_stat(IN p_loco_type  tinytext
                               , IN p_sorg_code tinytext
                               , IN p_lorg_code tinytext
                               , IN p_ispwu     tinytext
                               , IN p_line_code tinytext
                               , IN p_loco_code tinytext
                               , IN p_rminutes  int
                               , IN p_data_perm text
                               )
BEGIN
    DECLARE v_self_org VARCHAR(60);
    DECLARE v_over_org VARCHAR(60);
    DECLARE v_over VARCHAR(10);
    DECLARE v_self VARCHAR(10);
    DECLARE v_sorg_filter BOOLEAN;
    DECLARE v_sorg_obj VARCHAR(60);
    DECLARE v_ispwu BOOLEAN;
    DECLARE v_cc_org_code VARCHAR(60);
    DECLARE v_cc_porg_code VARCHAR(60);
    DECLARE v_cc_loco VARCHAR(60);
    DECLARE v_cc_dt DATETIME;
    DECLARE v_cc_id VARCHAR(60);
    DECLARE v_self_cnt INT;
    DECLARE v_over_cnt INT;
    DECLARE done BOOLEAN;

    DECLARE v_cur_loco CURSOR FOR SELECT locomotive_code, p_org_code, org_code, detect_time, id
                                  FROM wv_loco
                                  ORDER BY detect_time DESC;


    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    SET done = FALSE;

    set max_heap_table_size = 17179869184;

    DROP TABLE IF EXISTS wv_privs;

    CREATE TEMPORARY TABLE wv_privs
    (
        org_code VARCHAR(60)
    ) ENGINE MEMORY;

    call p_parse_privs(p_data_perm);


    BEGIN
        DECLARE v_sql,v_where TEXT;
        DECLARE done BOOLEAN default false;
        declare v_id varchar(40);
        declare v_dt datetime;

        DECLARE v_cur_ltr CURSOR FOR SELECT g_id gid, date(g_last_time) gdate
                                     FROM loco_lrt
                                     WHERE data_sort = 2
                                       AND g_id IS NOT NULL;

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

        call p_get_mod_sql('loco_curr_stat', 1, v_sql);

        set v_where :=" " ;
        if p_loco_type is not null then
            set v_where := concat(" and locomotive_code ", if(p_loco_type = 1, " ", " not "), " like 'CR%'");
        end if;

        if p_line_code is not null then
            set v_where := concat(v_where, " and line_code = '", p_line_code, "'");
        end if;

        if p_loco_code is not null then
            set v_where := concat(v_where, " and locomotive_code = '", p_loco_code, "'");
        end if;

        set v_sql := concat(v_sql, ifnull(v_where, " "));

        DROP TABLE IF EXISTS wv_loco;

        set @v_id := '---';
        set @v_dt := current_date();


        SET @sql := CONCAT('create temporary table wv_loco engine memory ', v_sql);
        prepare sqlstmt_1 from @sql;
        execute sqlstmt_1 using @v_id,@v_dt,@v_dt;
        deallocate prepare sqlstmt_1;

        SET @sql := CONCAT('insert into wv_loco ', v_sql);
        prepare sqlstmt_2 from @sql;

        OPEN v_cur_ltr;
        fetch_ltr:
        LOOP
            FETCH v_cur_ltr INTO v_id, v_dt;
            set @v_id := v_id;
            set @v_dt := v_dt;
            IF done THEN
                LEAVE fetch_ltr;
            END IF;

            EXECUTE sqlstmt_2 using @v_id,@v_dt,@v_dt;
        END LOOP;

        deallocate prepare sqlstmt_2;
    END;


    SET SQL_SAFE_UPDATES = 0;
    SET V_OVER := NULLIF(P_ISPWU, '0');
    SET v_ispwu := p_ispwu = '1';

    OPEN v_cur_loco;

    fetch_cursor:
    LOOP
        FETCH v_cur_loco INTO v_cc_loco, v_cc_porg_code, v_cc_org_code, v_cc_dt, v_cc_id;

        IF done THEN
            LEAVE fetch_cursor;
        END IF;

        IF p_sorg_code IS NOT NULL
        THEN
            SET v_sorg_obj := if(v_ispwu, v_cc_org_code, v_cc_porg_code);
            SET v_sorg_filter := v_sorg_obj LIKE concat(p_sorg_code, "%");

            IF NOT v_sorg_filter
            THEN
                DELETE
                FROM wv_loco
                WHERE id = v_cc_id;

                ITERATE fetch_cursor;
            END IF;
        END IF;


        IF p_lorg_code IS NULL
        THEN
            UPDATE wv_loco v
            SET loco_type = '自有'
            WHERE id = v_cc_id;

            ITERATE fetch_cursor;
        END IF;


        IF v_ispwu
        THEN
            SELECT max(org_code)
            INTO v_self_org
            FROM locomotive l
            WHERE l.locomotive_code = v_cc_loco
              AND l.org_code IS NOT NULL;
        ELSE
            SET v_self_org := v_cc_porg_code;
        END IF;

        SET v_over_org := CASE WHEN v_ispwu THEN v_cc_org_code END;

        SELECT count(*)
        INTO v_self_cnt
        FROM wv_privs
        WHERE v_self_org LIKE concat(org_code, '%');


        SELECT count(*)
        INTO v_over_cnt
        FROM wv_privs
        WHERE v_over_org LIKE concat(org_code, '%');


        IF v_self_cnt = 0 AND (v_over_cnt = 0 OR v_over_cnt > 0 AND v_cc_dt < now() - INTERVAL p_rminutes MINUTE)
        THEN
            DELETE
            FROM wv_loco
            WHERE id = v_cc_id;
        ELSE
            IF v_self_cnt > 0 AND v_over_cnt > 0
            THEN
                ITERATE fetch_cursor;
            END IF;

            IF v_self_cnt > 0 AND v_over_cnt = 0
            THEN
                UPDATE wv_loco
                SET loco_type = '自有'
                WHERE locomotive_code = v_cc_loco;
            ELSE
                UPDATE wv_loco
                SET loco_type = '途经'
                WHERE locomotive_code = v_cc_loco;
            END IF;
        END IF;
    END LOOP fetch_cursor;

    CLOSE v_cur_loco;

    begin
        declare v_done boolean default false;
        declare v_sql text;
        declare v_id varchar(40);
        declare v_dt datetime;

        declare v_cur_mon cursor for
            select id, date(detect_time) detect_time
            from wv_loco;

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

        call p_get_mod_sql('loco_curr_stat', 2, v_sql);

        drop table if exists wv_sms_mon;

        set @sql := concat(' create temporary table wv_sms_mon engine memory ', v_sql);
        prepare sqlstmt from @sql;

        set @v_id := '---';
        set @v_dt := current_date() + interval 1 day;
        execute sqlstmt using @v_id, @v_dt, @v_dt;

        deallocate prepare sqlstmt;

        set @sql := concat(' insert into wv_sms_mon ', v_sql);
        prepare sqlstmt from @sql;

        open v_cur_mon;
        fetch_sec:
        begin
            fetch v_cur_mon into v_id,v_dt;
            set @v_id := v_id;
            set @v_dt := v_dt;
            if v_done then
                leave fetch_sec ;
            end if;
            execute sqlstmt using @v_id, @v_dt, @v_dt;

        end;

        deallocate prepare sqlstmt;
        close v_cur_mon;
    end;

    call p_get_mod_sql('loco_curr_stat', 3, @sql);
    prepare sqlstmt from @sql;
    execute sqlstmt;
    deallocate prepare sqlstmt;
END //

