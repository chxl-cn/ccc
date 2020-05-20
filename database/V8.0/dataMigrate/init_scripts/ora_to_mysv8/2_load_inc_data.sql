/*
    本脚本作用是抽取增量数据，以方便快速进行数据迁移，但需指定如下条件：
    1、提前时间点：xxxxxxx
    2、日期格式为 yyyymmdd (年月日)

    注：在全量数据迁移之后的期间，本脚本所包含的模型不能有修改调整，否则，应在修正相应的分区表，同时修正查询列表字段

 */


insert into alarm_mg_part
SELECT *
FROM alarm
where raised_time >= to_date('xxxxxxxx', 'yyyymmdd')
;

insert into alarm_aux_mg_part
SELECT *
FROM alarm_aux
WHERE raised_time_aux >= to_date('xxxxxxxx', 'yyyymmdd')
;


insert into alarm_img_data_mg_part
SELECT *
FROM alarm_img_data
WHERE raise_time >= to_date('xxxxxxxx', 'yyyymmdd')
;


insert into c3_sms_mg_part
SELECT *
FROM c3_sms
WHERE detect_time >= to_date('xxxxxxxx', 'yyyymmdd');
