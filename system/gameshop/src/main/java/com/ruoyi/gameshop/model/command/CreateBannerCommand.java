package com.ruoyi.gameshop.model.command;

/** Service 业务输入；不作为数据库实体。 */
public record CreateBannerCommand(
    String title, String imageUrl, String targetPropId, Integer sort, String status) {}
