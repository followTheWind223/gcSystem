package com.gc.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record PublicReviewResult(
    String reviewId, ReviewerResult reviewer, Integer score, String content, String createdAt) {}
