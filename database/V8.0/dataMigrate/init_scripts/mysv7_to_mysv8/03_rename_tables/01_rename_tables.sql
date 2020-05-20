DELIMITER ;
ALTER TABLE alarm RENAME TO alarm_mg_org;
ALTER TABLE alarm_pnew RENAME TO alarm;

ALTER TABLE alarm_aux RENAME TO alarm_aux_mg_org;
ALTER TABLE alarm_aux_pnew RENAME TO alarm_aux;

ALTER TABLE nos_aa RENAME TO nos_aa_mg_org;
ALTER TABLE nos_aa_pnew RENAME TO nos_aa;

ALTER TABLE c3_sms RENAME TO c3_sms_mg_org;
ALTER TABLE c3_sms_pnew RENAME TO c3_sms;

ALTER TABLE c3_sms_monitor_pnew RENAME TO c3_sms_monitor;
ALTER TABLE nos_ac RENAME TO nos_ac_mg_org;
ALTER TABLE nos_ac_pnew RENAME TO nos_ac;


