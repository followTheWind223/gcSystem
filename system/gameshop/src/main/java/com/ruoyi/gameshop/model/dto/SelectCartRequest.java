package com.ruoyi.gameshop.model.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import java.util.List;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record SelectCartRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "cartItemIds", required = true)
        @NotNull
        @Size(min = 1, max = 100)
        @Valid
        List<String> cartItemIds,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "checked", required = true) @NotNull
        Boolean checked) {}
