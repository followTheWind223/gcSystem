package com.gc.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record AdminMemberResult(
    String memberId,
    String username,
    String nickname,
    String avatarUrl,
    String emailMasked,
    String phoneMasked,
    String status,
    String createdAt,
    String lastLoginAt) {}
