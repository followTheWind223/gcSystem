package com.gc.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record ItemErrorResult(
    String propId,
    String cartItemId,
    String reason,
    Integer availableStock,
    String currentUnitPrice) {}
