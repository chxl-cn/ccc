DELIMITER  ;
drop PROCEDURE if EXISTS alarmconfirm;

DELIMITER //
CREATE PROCEDURE alarmconfirm(IN alarmid tinytext
                             , IN i_aflg_code tinytext
                             , IN i_aflg_name tinytext
                             , IN i_severity tinytext
                             , IN i_statusname tinytext
                             , IN i_statuscode tinytext
                             , IN i_alarm_analysis tinytext
                             , IN i_proposal tinytext
                             , IN i_remark tinytext
                             , IN i_report_person tinytext
                             , IN i_report_date DATETIME
                             , IN i_code tinytext
                             , IN i_cust_alarm_code tinytext
                             , IN i_code_name tinytext
                             , IN btntype tinytext
                             , OUT results INT
                             , IN i_statustime DATETIME
                             , IN i_sample_code tinytext
                             , IN i_sample_name tinytext
                             , IN i_sample_d_code tinytext
                             , IN i_sample_d_name tinytext
                             , IN i_scence_sample_name tinytext
                             , IN i_scence_sample_code tinytext
                             , in p_raised_time datetime)
BEGIN
    ##DECLARE v_cnt，v_sample_d_cnt INT;
    #DECLARE v_sample_d_code，v_sample_d_name tinytext;
    declare v_reportwordstatus tinytext;


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

    /*
    SELECT count(*)
    INTO v_cnt
    FROM alarm_aux a
    WHERE a.alarm_id = alarmid
      and a.raised_time = p_raised_time;
    */


    /*
    IF v_cnt > 0
    THEN
        IF btntype = 'btnOk' AND (i_severity = '一类' OR i_severity = '二类' OR i_sample_code = 'DRTFLG_ZHB')
        THEN
            UPDATE alarm a
            SET a.aflg_code        = i_aflg_code
              , a.reportwordstatus = 'WAIT'

            WHERE a.alarm_id = alarmid
              and raised_time = p_raised_time;
        ELSE
            UPDATE alarm_aux a
            SET a.aflg_code        = i_aflg_code
              , a.reportwordstatus = NULL
              , a.reportwordurl    = NULL
            WHERE a.alarm_id = alarmid;
        END IF;
    ELSE
        IF btntype = 'btnOk' AND (i_severity = '一类' OR i_severity = '二类' OR i_sample_code = 'DRTFLG_ZHB')
        THEN
            INSERT INTO alarm_aux( alarm_id
                                 , id
                                 , aflg_code
                                 , reportwordstatus)
            VALUES ( alarmid
                   , alarmid
                   , i_aflg_code
                   , 'WAIT');
        ELSE
            INSERT INTO alarm_aux( alarm_id
                                 , id
                                 , aflg_code)
            VALUES ( alarmid
                   , alarmid
                   , i_aflg_code);
        END IF;
    END IF;
    */


    /*
    IF btntype = 'btnOk'
    THEN
        UPDATE alarm b
        SET b.severity        = i_severity
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
        SET b.severity        = i_severity
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
    */

    IF btntype = 'btnOk' AND (i_severity = '一类' OR i_severity = '二类' OR i_sample_code = 'DRTFLG_ZHB')
    then
        set v_reportwordstatus = 'WAIT' ;
    end if;

    UPDATE alarm b
    SET b.severity         = i_severity
      , b.status           = i_statuscode
      , b.status_time      = i_statustime
      , b.data_type        = if(btntype = 'btnOk', 'FAULT', 'ALARM')
      , b.alarm_analysis   = i_alarm_analysis
      , b.remark           = i_remark
      , b.report_person    = i_report_person
      , b.report_date      = i_report_date
      , b.code             = i_code
      , b.cust_alarm_code  = i_cust_alarm_code
      , b.reportwordstatus = v_reportwordstatus
      , aflg_code          = i_aflg_code
    WHERE b.id = alarmid
      and b.raised_time = p_raised_time;

    SET results := 1;

    COMMIT;
END //

