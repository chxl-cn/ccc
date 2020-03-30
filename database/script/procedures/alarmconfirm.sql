DELIMITER  ;
drop PROCEDURE  if EXISTS alarmconfirm ;

DELIMITER //
CREATE PROCEDURE alarmconfirm(
                               IN alarmid              VARCHAR(100)
                             , IN i_aflg_code          VARCHAR(100)
                             , IN i_aflg_name          VARCHAR(100)
                             , IN i_severity           VARCHAR(100)
                             , IN i_statusname         VARCHAR(100)
                             , IN i_statuscode         VARCHAR(100)
                             , IN i_alarm_analysis     VARCHAR(100)
                             , IN i_proposal           VARCHAR(100)
                             , IN i_remark             VARCHAR(100)
                             , IN i_report_person      VARCHAR(100)
                             , IN i_report_date        DATETIME
                             , IN i_code               VARCHAR(100)
                             , IN i_cust_alarm_code    VARCHAR(100)
                             , IN i_code_name          VARCHAR(100)
                             , IN btntype              VARCHAR(100)
                             , OUT results             INT
                             , IN i_statustime         DATETIME
                             , IN i_sample_code        VARCHAR(100)
                             , IN i_sample_name        VARCHAR(100)
                             , IN i_sample_d_code      VARCHAR(100)
                             , IN i_sample_d_name      VARCHAR(100)
                             , IN i_scence_sample_name VARCHAR(100)
                             , IN i_scence_sample_code VARCHAR(100) )
BEGIN
    DECLARE v_cnt INT;
    DECLARE v_sample_d_cnt INT;
    DECLARE v_sample_d_code VARCHAR(100);
    DECLARE v_sample_d_name VARCHAR(100);

    SET results := 0;

    SET max_heap_table_size = 17179869184;

   /*
    IF i_sample_d_code IS NOT NULL
    THEN
        SET v_sample_d_code := i_sample_d_code;
        SET v_sample_d_name := i_sample_d_name;
    ELSE
        IF i_sample_code = 'DRTFLG_ZHB'
        THEN
            SELECT
                d.dic_code
                INTO v_sample_d_code
                FROM
                    sample_afcode_relation s
                    , sys_dic d
                WHERE
                      s.sample_code = d.dic_code
                  AND s.alarm_code = i_code;
        END IF;
    END IF;
*/

    SELECT
        count(*)
        INTO v_cnt
        FROM alarm_aux a
        WHERE a.alarm_id = alarmid;

    IF v_cnt > 0
    THEN
        IF btntype = 'btnOk' AND (i_severity = '一类' OR i_severity = '二类' OR i_sample_code = 'DRTFLG_ZHB')
        THEN
            UPDATE alarm_aux a
            SET
                a.aflg_code        = i_aflg_code
              , a.reportwordstatus = 'WAIT'
                WHERE a.alarm_id = alarmid;
        ELSE
            UPDATE alarm_aux a
            SET
                a.aflg_code        = i_aflg_code
              , a.reportwordstatus = NULL
              , a.reportwordurl    = NULL


                WHERE a.alarm_id = alarmid;
        END IF;
    ELSE
        IF btntype = 'btnOk' AND (i_severity = '一类' OR i_severity = '二类' OR i_sample_code = 'DRTFLG_ZHB')
        THEN
            INSERT INTO
                alarm_aux(
                           alarm_id
                         , id
                         , aflg_code
                         , reportwordstatus
            )
                VALUES
                (
                    alarmid
                ,   alarmid
                ,   i_aflg_code
                ,   'WAIT'
                );
        ELSE
            INSERT INTO
                alarm_aux(
                           alarm_id
                         , id
                         , aflg_code
            )
                VALUES
                (
                    alarmid
                ,   alarmid
                ,   i_aflg_code
                );
        END IF;
    END IF;


    IF btntype = 'btnOk'
    THEN
        UPDATE alarm b
        SET
            b.severity        = i_severity
          , b.status          = i_statuscode
          , b.status_time     = i_statustime
          , b.data_type       = 'FAULT'
          , b.alarm_analysis  = i_alarm_analysis
          , b.remark          = i_remark
          , b.report_person   = i_report_person
          , b.report_date     = i_report_date
          , b.code            = i_code
          , b.cust_alarm_code = i_cust_alarm_code

            WHERE b.id = alarmid;
    ELSE
        UPDATE alarm b
        SET
            b.severity        = i_severity
          , b.status          = i_statuscode
          , b.status_time     = i_statustime
          , b.alarm_analysis  = i_alarm_analysis
          , b.remark          = i_remark
          , b.report_person   = i_report_person
          , b.report_date     = i_report_date
          , b.code            = i_code
          , b.cust_alarm_code = i_cust_alarm_code

            WHERE b.id = alarmid;
    END IF;

    SET results := 1;
    COMMIT;
END //

