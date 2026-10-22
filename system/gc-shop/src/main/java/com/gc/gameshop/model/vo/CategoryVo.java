package com.gc.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record CategoryVo(
    String categoryId, String name, String iconUrl, Integer sort, Boolean recommended) {}
