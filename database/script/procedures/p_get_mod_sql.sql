delimiter ;
drop procedure if exists p_get_mod_sql;

delimiter //
create procedure p_get_mod_sql(p_mod_name      varchar(40)
                              , p_sql_no       int
                              , out p_sql_text text
                              )
begin
    select sql_text
    into p_sql_text
    from mis_mod_sql
    where mod_name = p_mod_name
      and sql_no = p_sql_no;
end //
