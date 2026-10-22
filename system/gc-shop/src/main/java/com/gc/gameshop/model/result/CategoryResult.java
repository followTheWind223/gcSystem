package com.gc.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record CategoryResult(
    String categoryId, String name, String iconUrl, Integer sort, Boolean recommended) {}
