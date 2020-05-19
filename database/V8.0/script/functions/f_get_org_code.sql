delimiter ;
drop function if exists f_get_org_code;


delimiter //
create function f_get_org_code(p_org_code varchar(100), p_pos int)
    returns varchar(60)
    deterministic
begin
    declare ret varchar(60);
    set ret = regexp_substr(p_org_code, '[[:alnum:]]+\\$[[:alnum:]]+', 1, p_pos);

    return ret;

end //

