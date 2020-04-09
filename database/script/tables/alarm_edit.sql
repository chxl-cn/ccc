CREATE TABLE `alarm_edit`
(
    `alarmid`    VARCHAR(40) NOT NULL,
    `raisedtime` DATETIME,
    `editor`     VARCHAR(10),
    `edittime`   DATETIME,
    `content`    TEXT,
    KEY (alarmid),
    KEY (raisedtime)
) ENGINE = innodb
  DEFAULT CHARSET = utf8mb4;