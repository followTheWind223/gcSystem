package com.ruoyi.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record UpdateCartRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "quantity", required = true)
        @NotNull
        @Min(1)
        @Max(99)
        Integer quantity,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "checked", required = true) @NotNull
        Boolean checked) {}
