package com.ruoyi.gameshop.model.vo;

import java.util.List;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record OrderItemVo(
    String propId,
    String propName,
    String coverUrl,
    List<SpecificationVo> specs,
    String unitPrice,
    Integer quantity,
    String subtotal,
    String orderItemId,
    Boolean canReview,
    String reviewId) {}
