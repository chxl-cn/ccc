ALTER TABLE alarm RENAME TO alarm_mg_org;
ALTER TABLE alarm_mg_part RENAME TO alarm;

ALTER TABLE alarm_aux RENAME TO alarm_aux_mg_org;
ALTER TABLE alarm_aux_mg_part RENAME TO alarm_aux;

ALTER TABLE alarm_img_data RENAME TO alarm_img_data_mg_org;
ALTER TABLE alarm_img_data_mg_part RENAME TO alarm_img_data;

ALTER TABLE c3_sms RENAME TO c3_sm_mg_org;
ALTER TABLE c3_sms_mg_part RENAME TO c3_sms;