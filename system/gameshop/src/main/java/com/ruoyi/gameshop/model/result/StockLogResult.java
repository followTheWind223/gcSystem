package com.ruoyi.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record StockLogResult(
    String stockLogId,
    String propId,
    String propName,
    Integer changeQty,
    Integer beforeStock,
    Integer afterStock,
    String bizType,
    String bizKey,
    String operatorType,
    String operatorId,
    String reason,
    String createdAt) {}
