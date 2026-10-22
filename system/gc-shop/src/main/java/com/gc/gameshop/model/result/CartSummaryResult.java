package com.gc.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record CartSummaryResult(
    Integer totalItemCount,
    Integer totalQuantity,
    Integer selectedItemCount,
    Integer selectedQuantity,
    String selectedAmount,
    Integer invalidItemCount) {}
