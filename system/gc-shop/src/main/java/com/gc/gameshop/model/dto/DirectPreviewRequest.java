package com.gc.gameshop.model.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import java.util.List;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record DirectPreviewRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "source", required = true)
        @NotNull
        @Pattern(regexp = "^(?:DIRECT)$")
        String source,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "items", required = true)
        @NotNull
        @Size(min = 1, max = 1)
        @Valid
        List<CheckoutItemRequest> items) {}
