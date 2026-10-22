package com.ruoyi.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record CartItemVo(
    String cartItemId,
    String propId,
    String propName,
    String categoryName,
    String coverUrl,
    String unitPrice,
    Integer quantity,
    Boolean checked,
    Integer stock,
    String availability,
    Boolean canCheckout,
    String subtotal,
    String updatedAt) {}
