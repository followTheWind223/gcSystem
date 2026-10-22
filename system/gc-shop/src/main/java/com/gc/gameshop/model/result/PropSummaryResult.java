package com.gc.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record PropSummaryResult(
    String propId,
    String categoryId,
    String categoryName,
    String name,
    String coverUrl,
    String price,
    String originalPrice,
    Integer stock,
    Integer sales,
    String onSaleAt,
    Boolean canPurchase) {}
