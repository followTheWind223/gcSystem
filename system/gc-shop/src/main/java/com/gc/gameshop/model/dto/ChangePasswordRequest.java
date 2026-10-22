package com.gc.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record ChangePasswordRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "oldPassword", required = true)
        @NotNull
        @Size(min = 1, max = 64)
        String oldPassword,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "newPassword", required = true)
        @NotNull
        @Size(min = 8, max = 64)
        @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*[0-9])[!-~]{8,64}$")
        String newPassword) {}
