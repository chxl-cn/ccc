CREATE TABLE `getfiletask_queue`
(
    `id`                varchar(100) NOT NULL,
    `taskid`            varchar(100) NOT NULL,
    `locomotive_code`   varchar(50),
    `getdatatime`       datetime,
    `task_queue_status` varchar(100),
    `bowposition`       varchar(50),
    PRIMARY KEY (`id`),
    KEY `ix_task_queue_taskid` (`taskid`),
    KEY `ix_getfiletask_queue_id` (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
