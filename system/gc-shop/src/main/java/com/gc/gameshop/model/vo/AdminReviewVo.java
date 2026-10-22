package com.gc.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record AdminReviewVo(
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
    String createdAt,
    String memberId,
    String username) {}
