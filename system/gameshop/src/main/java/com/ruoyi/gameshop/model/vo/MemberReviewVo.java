package com.ruoyi.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record MemberReviewVo(
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
