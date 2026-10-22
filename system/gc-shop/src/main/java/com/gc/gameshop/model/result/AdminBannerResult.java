package com.gc.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record AdminBannerResult(
    String bannerId,
    String title,
    String imageUrl,
    String targetPropId,
    Integer sort,
    String status,
    Integer version,
    String createdAt,
    String updatedAt) {}
