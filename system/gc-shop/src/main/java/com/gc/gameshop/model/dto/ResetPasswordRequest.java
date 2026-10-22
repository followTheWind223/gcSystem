package com.gc.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record ResetPasswordRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "email", required = true)
        @NotNull
        @Size(max = 254)
        @Email
        String email,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "emailCode", required = true)
        @NotNull
        @Pattern(regexp = "^[0-9]{6}$")
        String emailCode,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "newPassword", required = true)
        @NotNull
        @Size(min = 8, max = 64)
        @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*[0-9])[!-~]{8,64}$")
        String newPassword) {
  public ResetPasswordRequest {
    email = email == null ? null : email.trim().toLowerCase(java.util.Locale.ROOT);
  }
}
