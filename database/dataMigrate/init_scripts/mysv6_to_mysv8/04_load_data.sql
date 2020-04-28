/*
执行脚本前，应xxxxxxxx替换成对应的历史数据日期
 */

DELIMITER  ;

INSERT INTO alarm_aux_mg_part
SELECT *
FROM alarm_aux x
WHERE x.raised_time_aux < 'xxxxxxxx';

INSERT INTO alarm_img_data_mg_part
SELECT *
FROM alarm_img_data d
WHERE d.raise_time < 'xxxxxxxx';
