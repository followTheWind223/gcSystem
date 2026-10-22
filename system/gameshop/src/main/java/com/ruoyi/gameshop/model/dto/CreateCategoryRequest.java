package com.ruoyi.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record CreateCategoryRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "name", required = true)
        @NotNull
        @Size(min = 2, max = 30)
        String name,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "iconUrl", required = true)
        @Pattern(regexp = "^/api/mall/media/[a-f0-9]{32}\\.(png|jpg|webp)$")
        String iconUrl,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "sort", required = true)
        @NotNull
        @Min(0)
        @Max(9999)
        Integer sort,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "recommended", required = true) @NotNull
        Boolean recommended,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "status", required = true)
        @NotNull
        @Pattern(regexp = "^(?:0|1)$")
        String status) {}
