CREATE TABLE `alarm_edit`
(
    `alarmid`    VARCHAR(40) NOT NULL,
    `raisedtime` DATETIME,
    `editor`     VARCHAR(10),
    `edittime`   DATETIME,
    `content`    TEXT,
    KEY (alarmid)
) ENGINE = innodb
  DEFAULT CHARSET = utf8mb4
    PARTITION BY RANGE COLUMNS (raisedtime)
        (PARTITION p_20180101 VALUES LESS THAN ("2018-01-02")

        )
;