package com.ruoyi.gameshop.model.result;

import java.util.List;

/** Service 业务输出；不作为数据库实体。 */
public record OrderItemResult(
    String propId,
    String propName,
    String coverUrl,
    List<SpecificationResult> specs,
    String unitPrice,
    Integer quantity,
    String subtotal,
    String orderItemId,
    Boolean canReview,
    String reviewId) {}
