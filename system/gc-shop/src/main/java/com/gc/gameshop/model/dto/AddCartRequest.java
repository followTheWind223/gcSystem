package com.gc.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record AddCartRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "propId", required = true)
        @NotNull
        @Size(max = 19)
        @Pattern(regexp = "^[1-9][0-9]{0,18}$")
        String propId,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "quantity", required = true)
        @NotNull
        @Min(1)
        @Max(99)
        Integer quantity) {}
