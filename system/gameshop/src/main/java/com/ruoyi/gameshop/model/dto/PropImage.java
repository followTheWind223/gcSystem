package com.ruoyi.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record PropImage(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "url", required = true)
        @NotNull
        @Pattern(regexp = "^/api/mall/media/[a-f0-9]{32}\\.(png|jpg|webp)$")
        String url,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "sort", required = true)
        @NotNull
        @Min(0)
        @Max(9999)
        Integer sort) {}
