package com.ruoyi.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record AdminBannerVo(
    String bannerId,
    String title,
    String imageUrl,
    String targetPropId,
    Integer sort,
    String status,
    Integer version,
    String createdAt,
    String updatedAt) {}
