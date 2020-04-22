declare
    type trec is record (aid varchar2(40),mri varchar2(60));
    type tdr is table of trec ;
    vdr tdr := tdr();
begin
    for p in (select PARTITION_NAME from USER_TAB_PARTITIONS p where p.TABLE_NAME = 'alarm_aux' order by p.PARTITION_POSITION desc)
        loop
            begin
                execute immediate 'select alarm_id,min(ROWID) mrid from alarm_aux partition (' || p.PARTITION_NAME || ') group by alarm_id,having count(*) > 1'
                    bulk collect into vdr;
                for r in vdr.first .. vdr.LAST
                    loop
                        execute immediate 'delete from alarm_aux partition (' || p.PARTITION_NAME || ') where alarm_id=''' || vdr(r).aid || '''and rowid!=''' || vdr(r).mri ;
                    end loop;
                commit;
            exception
                when others then
                    DBMS_OUTPUT.PUT_LINE(sqlerrm)
            end;

        end loop;
end;