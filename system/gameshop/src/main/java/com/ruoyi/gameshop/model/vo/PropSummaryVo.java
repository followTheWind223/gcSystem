package com.ruoyi.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record PropSummaryVo(
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
