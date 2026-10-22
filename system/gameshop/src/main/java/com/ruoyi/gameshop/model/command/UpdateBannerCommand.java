package com.ruoyi.gameshop.model.command;

/** Service 业务输入；不作为数据库实体。 */
public record UpdateBannerCommand(
    String title,
    String imageUrl,
    String targetPropId,
    Integer sort,
    String status,
    Integer version) {}
