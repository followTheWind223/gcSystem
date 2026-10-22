package com.ruoyi.gameshop.model.command;

/** Service 业务输入；不作为数据库实体。 */
public record UpdateCategoryCommand(
    String name,
    String iconUrl,
    Integer sort,
    Boolean recommended,
    String status,
    Integer version) {}
