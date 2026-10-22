package com.ruoyi.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record UpdateBannerRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "title", required = true)
        @NotNull
        @Size(min = 1, max = 60)
        String title,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "imageUrl", required = true)
        @NotNull
        @Pattern(regexp = "^/api/mall/media/[a-f0-9]{32}\\.(png|jpg|webp)$")
        String imageUrl,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "targetPropId", required = true)
        @NotNull
        @Size(max = 19)
        @Pattern(regexp = "^[1-9][0-9]{0,18}$")
        String targetPropId,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "sort", required = true)
        @NotNull
        @Min(0)
        @Max(9999)
        Integer sort,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "status", required = true)
        @NotNull
        @Pattern(regexp = "^(?:0|1)$")
        String status,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "version", required = true)
        @NotNull
        @Min(0)
        Integer version) {}
