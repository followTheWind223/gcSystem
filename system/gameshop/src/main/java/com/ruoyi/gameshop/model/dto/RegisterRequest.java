package com.ruoyi.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record RegisterRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "username", required = true)
        @NotNull
        @Pattern(regexp = "^[a-z][a-z0-9_]{3,19}$")
        String username,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "password", required = true)
        @NotNull
        @Size(min = 8, max = 64)
        @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*[0-9])[!-~]{8,64}$")
        String password,
    @Size(min = 2, max = 30) String nickname,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "email", required = true)
        @NotNull
        @Size(max = 254)
        @Email
        String email,
    @Pattern(regexp = "^[0-9]{6}$") String emailCode,
    @Size(max = 64) String captchaId,
    @Size(min = 1, max = 8) String captchaCode) {
  public RegisterRequest {
    username = username == null ? null : username.trim().toLowerCase(java.util.Locale.ROOT);
    email = email == null ? null : email.trim().toLowerCase(java.util.Locale.ROOT);
  }
}
