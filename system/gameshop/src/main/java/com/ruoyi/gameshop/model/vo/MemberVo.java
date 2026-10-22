package com.ruoyi.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record MemberVo(
    String memberId,
    String username,
    String nickname,
    String avatarUrl,
    String email,
    Boolean emailVerified,
    String phoneNumber,
    String createdAt) {}
