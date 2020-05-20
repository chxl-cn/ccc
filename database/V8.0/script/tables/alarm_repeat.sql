CREATE TABLE `alarm_repeat`
(
    `id`            VARCHAR(128) NOT NULL COMMENT '主报警id',
    `raised_time`   DATETIME     DEFAULT NULL COMMENT '主报警发生时间',
    `content`       TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '子报警json',
    `create_time`   DATETIME     DEFAULT NULL COMMENT '记录时间',
    `create_person` VARCHAR(128) DEFAULT NULL COMMENT '记录人',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
;