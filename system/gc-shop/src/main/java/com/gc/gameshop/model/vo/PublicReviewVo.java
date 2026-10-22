package com.gc.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record PublicReviewVo(
    String reviewId, ReviewerVo reviewer, Integer score, String content, String createdAt) {}
