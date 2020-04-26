DECLARE
    TYPE TR IS RECORD(
        AID VARCHAR2(60),
        RID VARCHAR2(60));
    TYPE TID IS TABLE OF TR;

    VIDS TID := TID();
    VRDS TID := TID();
    S    CLOB;
BEGIN
    FOR P IN (SELECT PARTITION_NAME FROM USER_TAB_PARTITIONS P WHERE P.TABLE_NAME = 'ALARM_AUX' ORDER BY P.PARTITION_POSITION DESC)
    LOOP
        BEGIN

            EXECUTE IMMEDIATE 'SELECT ALARM_ID, MIN(ROWID) MRID FROM ALARM_AUX PARTITION(' || P.PARTITION_NAME || ') GROUP BY ALARM_ID HAVING COUNT(*) > 1' BULK COLLECT
                INTO VIDS;

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
