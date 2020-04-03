CREATE TABLE `getfiletask`
(
    `taskid`         varchar(100) NOT NULL,
    `taskname`       varchar(100),
    `tasktype`       varchar(20),
    `alarm_id`       varchar(100),
    `line_code`      varchar(100),
    `position_code`  varchar(50),
    `brg_tun_code`   varchar(50),
    `direction`      varchar(100),
    `pole_number`    varchar(100),
    `pole_code`      varchar(50),
    `km_mark`        decimal(20, 0),
    `starttime`      datetime,
    `limit_times`    decimal(20, 0),
    `limit_endtime`  datetime,
    `limit_locos`    varchar(1000),
    `task_status`    varchar(10),
    `createusercode` varchar(128),
    `createusername` varchar(100),
    `createdatetime` datetime,
    `bowposition`    varchar(50),
    `rolling_num`    varchar(2),
    `source`         varchar(500),
    PRIMARY KEY (`taskid`),
    UNIQUE KEY `taskid` (`taskid`),
    KEY `ix_task_create_time` (`createdatetime`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
