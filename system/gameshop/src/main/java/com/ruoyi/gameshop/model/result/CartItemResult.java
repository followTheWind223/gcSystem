package com.ruoyi.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record CartItemResult(
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
