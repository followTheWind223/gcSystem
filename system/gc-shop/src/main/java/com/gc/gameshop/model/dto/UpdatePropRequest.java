package com.gc.gameshop.model.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import java.util.List;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record UpdatePropRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "categoryId", required = true)
        @NotNull
        @Size(max = 19)
        @Pattern(regexp = "^[1-9][0-9]{0,18}$")
        String categoryId,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "name", required = true)
        @NotNull
        @Size(min = 2, max = 80)
        String name,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "coverUrl", required = true)
        @NotNull
        @Pattern(regexp = "^/api/mall/media/[a-f0-9]{32}\\.(png|jpg|webp)$")
        String coverUrl,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "price", required = true)
        @NotNull
        @Pattern(regexp = "^(0|[1-9][0-9]{0,9})\\.[0-9]{2}$")
        String price,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "originalPrice", required = true)
        @Pattern(regexp = "^(0|[1-9][0-9]{0,9})\\.[0-9]{2}$")
        String originalPrice,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "images", required = true)
        @NotNull
        @Size(min = 1, max = 10)
        @Valid
        List<PropImage> images,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "detailHtml", required = true)
        @NotNull
        @Size(max = 20000)
        String detailHtml,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "specs", required = true)
        @NotNull
        @Size(max = 20)
        @Valid
        List<Specification> specs,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "deliveryFields", required = true)
        @NotNull
        @Size(min = 1, max = 3)
        @Valid
        List<String> deliveryFields,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "status", required = true)
        @NotNull
        @Pattern(regexp = "^(?:0|1)$")
        String status,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "version", required = true)
        @NotNull
        @Min(0)
        Integer version) {}
