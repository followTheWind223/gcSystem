package com.gc.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record MockPayRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "result", required = true)
        @NotNull
        @Pattern(regexp = "^(?:SUCCESS|FAIL)$")
        String result) {}
