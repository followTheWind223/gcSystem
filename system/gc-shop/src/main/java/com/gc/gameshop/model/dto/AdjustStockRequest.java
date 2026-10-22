package com.gc.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record AdjustStockRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "requestKey", required = true) @NotNull
        String requestKey,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "delta", required = true)
        @NotNull
        @Min(-1000000000)
        @Max(1000000000)
        Integer delta,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "reason", required = true)
        @NotNull
        @Size(min = 2, max = 200)
        String reason) {}
