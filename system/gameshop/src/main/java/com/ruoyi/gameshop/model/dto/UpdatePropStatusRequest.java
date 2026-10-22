package com.ruoyi.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record UpdatePropStatusRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "status", required = true)
        @NotNull
        @Pattern(regexp = "^(?:0|1)$")
        String status,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "version", required = true)
        @NotNull
        @Min(0)
        Integer version) {}
