package com.gc.gameshop.model.command;

/** Service 业务输入；不作为数据库实体。 */
public record CreateCategoryCommand(
    String name, String iconUrl, Integer sort, Boolean recommended, String status) {}
