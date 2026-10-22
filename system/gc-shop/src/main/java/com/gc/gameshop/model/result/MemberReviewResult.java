package com.gc.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record MemberReviewResult(
    String reviewId,
    String propId,
    String propName,
    String coverUrl,
    String orderNo,
    String orderItemId,
    Integer score,
    String content,
    String status,
    String hideReason,
    String createdAt) {}
