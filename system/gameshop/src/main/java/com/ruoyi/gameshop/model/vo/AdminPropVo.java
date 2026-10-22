package com.ruoyi.gameshop.model.vo;

import java.util.List;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record AdminPropVo(
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
    Boolean canPurchase,
    List<PropImageVo> images,
    String detailHtml,
    List<SpecificationVo> specs,
    List<String> deliveryFields,
    Integer reviewCount,
    Double averageScore,
    String status,
    Integer version,
    String createdAt,
    String updatedAt) {}
