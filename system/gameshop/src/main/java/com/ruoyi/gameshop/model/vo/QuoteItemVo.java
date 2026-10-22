package com.ruoyi.gameshop.model.vo;

import java.util.List;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record QuoteItemVo(
    String propId,
    String cartItemId,
    String propName,
    String coverUrl,
    List<SpecificationVo> specs,
    String unitPrice,
    Integer quantity,
    String subtotal,
    Integer stock) {}
