package com.ruoyi.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record StockLogVo(
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
