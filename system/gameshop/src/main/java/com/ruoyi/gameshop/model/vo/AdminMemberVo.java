package com.ruoyi.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record AdminMemberVo(
    String memberId,
    String username,
    String nickname,
    String avatarUrl,
    String emailMasked,
    String phoneMasked,
    String status,
    String createdAt,
    String lastLoginAt) {}
