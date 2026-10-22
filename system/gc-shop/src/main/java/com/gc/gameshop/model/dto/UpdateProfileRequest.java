package com.gc.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record UpdateProfileRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "nickname", required = true)
        @NotNull
        @Size(min = 2, max = 30)
        String nickname,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "phoneNumber", required = true)
        @Size(min = 7, max = 20)
        @Pattern(regexp = "^\\+?[0-9 -]{7,20}$")
        String phoneNumber) {}
