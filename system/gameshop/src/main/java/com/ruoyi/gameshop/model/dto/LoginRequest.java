package com.ruoyi.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record LoginRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "username", required = true)
        @NotNull
        @Pattern(regexp = "^[a-z][a-z0-9_]{3,19}$")
        String username,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "password", required = true)
        @NotNull
        @Size(min = 8, max = 64)
        @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*[0-9])[!-~]{8,64}$")
        String password,
    @Size(max = 64) String captchaId,
    @Size(min = 1, max = 8) String captchaCode) {
  public LoginRequest {
    username = username == null ? null : username.trim().toLowerCase(java.util.Locale.ROOT);
  }
}
