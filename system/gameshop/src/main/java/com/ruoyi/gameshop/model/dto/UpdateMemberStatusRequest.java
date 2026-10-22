package com.ruoyi.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record UpdateMemberStatusRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "status", required = true)
        @NotNull
        @Pattern(regexp = "^(?:0|1)$")
        String status,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "reason", required = true)
        @NotNull
        @Size(min = 2, max = 200)
        String reason) {}
