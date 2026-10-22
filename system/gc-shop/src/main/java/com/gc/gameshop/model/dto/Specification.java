package com.gc.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record Specification(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "name", required = true)
        @NotNull
        @Size(min = 1, max = 30)
        String name,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "value", required = true)
        @NotNull
        @Size(min = 1, max = 100)
        String value) {}
