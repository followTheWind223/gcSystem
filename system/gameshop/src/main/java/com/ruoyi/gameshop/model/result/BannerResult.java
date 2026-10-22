package com.ruoyi.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record BannerResult(
    String bannerId, String title, String imageUrl, String targetPropId, Integer sort) {}
