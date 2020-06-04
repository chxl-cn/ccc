/*
 指定参数
    1:数据抽取日期：xxxxxxxx
    2:数据抽取类型：1-增量；0-历史
    3:现场最小业务数据时间
 */
DELIMITER  ;
CALL p_load_data_proc("xxxxxxxx", 0,"xxxxxxxx");