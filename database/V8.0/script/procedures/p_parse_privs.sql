delimiter ;
drop procedure if exists p_parse_privs;

delimiter //
create procedure p_parse_privs(p_data_perm text
                              )
proc_body:
begin
    DECLARE v_ip INT;
    DECLARE v_is INT;
    DECLARE v_ie INT;
    DECLARE v_org VARCHAR(60);

    if p_data_perm is null then
        leave proc_body ;
    end if;
    SET v_ip = 1;

    etlorg:
    LOOP
        SET v_ip = regexp_instr(p_data_perm, "'", v_ip, 1);

        IF v_ip = 0
        THEN
            LEAVE etlorg;
        END IF;

        SET v_is = v_ip;

        SET v_ip = regexp_instr(p_data_perm, "'", v_ip + 1, 1);

        IF v_ip = 0
        THEN
            LEAVE etlorg;
        END IF;

        SET v_ie = v_ip;

        SET v_org = substr(p_data_perm, v_is, v_ie - v_is + 1);
        SET v_org = replace(v_org, "'", "");

        INSERT INTO wv_privs
        VALUES (replace(v_org, "%", ""));

        SET v_ip = v_ip + 1;
    END LOOP etlorg;
end //