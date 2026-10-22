package com.gc.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record OrderLogVo(String fromStatus, String toStatus, String reason, String createdAt) {}
