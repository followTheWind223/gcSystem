package com.ruoyi.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record OrderLogResult(String fromStatus, String toStatus, String reason, String createdAt) {}
