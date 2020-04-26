/*
  替换xxxxxxxx 为指定日期，其日期格式：yyyymmdd

 */

DECLARE
    TYPE TR IS RECORD (
        AID VARCHAR2(60),
        RID VARCHAR2(60));
    TYPE TID IS TABLE OF TR;

    VIDS       TID := TID();
    VRDS       TID := TID();
    v_sql      varchar2(1000) ;
    v_old_date date ;
    v_dyn_date date;
BEGIN
    v_old_date := to_date('xxxxxxxx', 'yyyymmdd');
    FOR P IN (SELECT PARTITION_NAME, p.HIGH_VALUE FROM USER_TAB_PARTITIONS P WHERE P.TABLE_NAME = 'ALARM_AUX' ORDER BY P.PARTITION_POSITION DESC)
        LOOP
            execute immediate 'select ' || p.HIGH_VALUE || ' from dual ' into v_dyn_date;
            continue when v_dyn_date >= v_old_date;

            BEGIN
                v_sql := replace('SELECT ALARM_ID,MIN(ROWID) MRID FROM ALARM_AUX PARTITION( :PARTITION_NAME ) GROUP BY ALARM_ID HAVING COUNT(*) > 1', ':PARTITION_NAME', p.PARTITION_NAME);

                EXECUTE IMMEDIATE v_sql BULK COLLECT INTO VIDS;

                CONTINUE WHEN VIDS.COUNT < 1;

                FOR R IN VIDS.FIRST .. VIDS.LAST
                    LOOP
                        EXECUTE IMMEDIATE 'delete from alarm_aux partition (' || P.PARTITION_NAME || ') where alarm_id=''' || VIDS(R).AID || '''and rowid !=''' || VRDS(R).RID || '''';
                    END LOOP;

                COMMIT;
                DBMS_OUTPUT.PUT_LINE(P.PARTITION_NAME);
            EXCEPTION

                WHEN OTHERS THEN
                    ROLLBACK;
                    DBMS_OUTPUT.PUT_LINE(SQLERRM);
            END;

        END LOOP;
END;
/
