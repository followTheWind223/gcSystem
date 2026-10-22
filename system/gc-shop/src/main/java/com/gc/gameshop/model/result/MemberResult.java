package com.gc.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record MemberResult(
    String memberId,
    String username,
    String nickname,
    String avatarUrl,
    String email,
    Boolean emailVerified,
    String phoneNumber,
    String createdAt) {}
