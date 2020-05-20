delimiter ;
drop function if exists getlocatype;


delimiter //
create
    function getlocatype(loco_code varchar(40))
    returns tinyint
    deterministic
begin
    return loco_code like 'c%' ;
end //

