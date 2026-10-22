package com.gc.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record CreateReviewRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "orderItemId", required = true)
        @NotNull
        @Size(max = 19)
        @Pattern(regexp = "^[1-9][0-9]{0,18}$")
        String orderItemId,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "score", required = true)
        @NotNull
        @Min(1)
        @Max(5)
        Integer score,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "content", required = true)
        @NotNull
        @Size(min = 5, max = 1000)
        String content) {}
