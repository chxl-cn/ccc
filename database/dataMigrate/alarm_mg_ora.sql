SELECT /*+ use_SELECT /*+ use_hash(d a) use_hash(x a)*/
    A.ID,
    VENDOR,
    CATEGORY_CODE,
    DETECT_DEVICE_CODE,
    DATA_TYPE,
    DVALUE1,
    DVALUE2,
    DVALUE3,
    DVALUE4,
    DVALUE5,
    NVALUE1,
    NVALUE2,
    NVALUE3,
    NVALUE4,
    NVALUE5,
    NVALUE6,
    NVALUE8,
    NVALUE13,
    NVALUE14,
    NVALUE15,
    NVALUE16,
    CREATED_TIME,
    RAISED_TIME,
    REPORT_DATE,
    STATUS_TIME,
    REPORT_PERSON,
    IS_TYPICAL,
    SEVERITY,
    STATUS,
    CODE,
    CUST_ALARM_CODE,
    P_ORG_CODE,
    SVALUE8,
    SVALUE14,
    SVALUE15,
    KM_MARK,
    POLE_NUMBER,
    BRG_TUN_CODE,
    POSITION_CODE,
    DIRECTION,
    LINE_CODE,
    ORG_CODE,
    WORKSHOP_CODE,
    POWER_SECTION_CODE,
    BUREAU_CODE,
    ALARM_ANALYSIS,
    TASK_ID,
    TAX_MONITOR_STATUS,
    ROUTING_NO,
    AREA_NO,
    STATION_NO,
    SOURCE,
    EOAS_DIRECTION,
    EOAS_KM,
    EOAS_LOCATION,
    EOAS_TIME,
    EOAS_TRAIN_SPEED,
    RAISED_TIME_M,
    TAX_POSITION,
    TAX_SCHEDULE_STATUS,
    POS_CONFIRMED,
    IS_CUSTOMER_ANA,
    ORG_FILE_LOCATION,
    PIC_FILE_LOCATION,
    SUMMARY,
    REPAIR_DATE,
    NULL ISDAYREPORT,
    ISEXPORTREPORT,
    LOCK_PERSON_ID,
    IS_TRANS_ALLOWED,
    ACFLAG_CODE,
    SAMPLE_CODE,
    SCENCESAMPLE_CODE,
    ACCESSCOUNT,
    INITIAL_CODE,
    AFLG_CODE,
    ALGCODE,
    REPORTWORDSTATUS,
    RERUN_TYPE,
    SPARK_ELAPSE,
    ISBLACKCENTER,
    DEV_TYPE_ANA,
    SPART_PIXEL_PCT,
    SPART_PIXELS,
    GRAY_AVG_LEFT,
    GRAY_AVG_RIGHT,
    GRAY_AVG_BOW_RECT,
    SPARK_SHAPE,
    SPARK_NUM,
    DEVICE_ID,
    EOAS_TRAINNO,
    ALARM_REP_COUNT,
    SAMPLE_DETAIL_CODE,
    NULL        VALID_GPS,
    A.ID        ALARM_ID,
    BMI_FILE_NAME,
    RPT_FILE_NAME,
    BOW_OFFSET,
    GPS_BODY_DIRECTION,
    IMG_BODY_DIRECTION,
    REPORTWORDURL,
    LOCK_PERSON_NAME,
    LOCK_TIME,
    CONFIDENCE_LEVEL,
    RAISED_TIME RAISED_TIME_AUX,
    IS_ABNORMAL,
    SVALUE6,
    SVALUE7,
    SVALUE10,
    SVALUE12,
    SVALUE13,
    ALARM_REASON,
    NULL AIRESULT,
    REMARK,
    TRANS_INFO,
    DEV_NAME,
    STATION_NAME,
    PROCESS_DEPTNAME,
    REPORT_DEPTNAME,
    PLAN_ID,
    PLAN_TASK_ID,
    PROCESS_DATE,
    PROCESS_DETAILS,
    PROCESS_OVERDUE,
    PROCESS_PERSON,
    PROCESS_STATUS,
    PROCESS_TYPE,
    PROFESSION_TYPE,
    REPAIRED_PIC,
    REPAIRED_STATUS,
    REPAIR_METHOD,
    REPAIR_ORG,
    REPAIR_PERSON,
    REPORT_OVERDUE,
    REVIEW_INFO,
    REVIEW_PERSON,
    REVIEW_TIME,
    CHECK_DETAILS,
    CHECK_PERSON,
    CHECK_RESULT,
    HARDDISK_MANAGE_ID,
    ATTACHMENT,
    COMP_CODE,
    COMP_TYPE,
    NVALUE7,
    NVALUE9,
    NVALUE11,
    NVALUE12,
    NVALUE17,
    NVALUE18,
    NVALUE19,
    NVALUE20,
    POWER_DEVICE_CODE,
    POWER_DEVICE_TYPE,
    SUBSTATION_CODE,
    MAP_ADD_IMA,
    VI_ADD_IMA,
    OA_ADD_IMA,
    AFLG_NAME,
    INITIAL_CODE_NAME,
    ACFLAG_NAME,
    SAMPLE_NAME,
    SCENCESAMPLE_NAME,
    SAMPLE_DETAIL_NAME,
    ALGCODENAME,
    GIS_Y_O,
    GIS_Y,
    GIS_X_O,
    GIS_X,
    P_ORG_NAME,
    CODE_NAME,
    STATUS_NAME,
    LINE_NAME,
    POSITION_NAME,
    BRG_TUN_NAME,
    BUREAU_NAME,
    POWER_SECTION_NAME,
    WORKSHOP_NAME,
    ORG_NAME,
    SUBSTATION_NAME,
    SVALUE9,
    SVALUE11,
    DETAIL,
    DIR_PATH,
    proposal,
    NVALUE10,
    SVALUE1,
    SVALUE2,
    SVALUE3,
    SVALUE4,
    SVALUE5,
    severity initial_severity
FROM ALARM A
         LEFT JOIN ALARM_IMG_DATA D ON A.ID = D.ALARM_ID and D.RAISE_TIME >= to_date('{0}','yyyy/mm/dd') AND   D.RAISE_TIME < to_date('{1}','yyyy/mm/dd') 
         LEFT JOIN ALARM_AUX X ON A.ID = X.ALARM_ID and X.RAISED_TIME_AUX >= to_date('{0}','yyyy/mm/dd') AND X.RAISED_TIME_AUX < to_date('{1}','yyyy/mm/dd')
WHERE A.RAISED_TIME >= to_date('{0}','yyyy/mm/dd') AND
       A.RAISED_TIME < to_date('{1}','yyyy/mm/dd')