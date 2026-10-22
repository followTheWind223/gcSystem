package com.ruoyi.gameshop.model.result;

import java.util.List;

/** Service 业务输出；不作为数据库实体。 */
public record AdminPropResult(
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
    List<PropImageResult> images,
    String detailHtml,
    List<SpecificationResult> specs,
    List<String> deliveryFields,
    Integer reviewCount,
    Double averageScore,
    String status,
    Integer version,
    String createdAt,
    String updatedAt) {}
