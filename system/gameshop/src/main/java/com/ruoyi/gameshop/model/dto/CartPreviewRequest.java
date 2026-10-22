package com.ruoyi.gameshop.model.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import java.util.List;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record CartPreviewRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "source", required = true)
        @NotNull
        @Pattern(regexp = "^(?:CART)$")
        String source,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "cartItemIds", required = true)
        @NotNull
        @Size(min = 1, max = 50)
        @Valid
        List<String> cartItemIds) {}
