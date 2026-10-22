package com.ruoyi.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record EmailCodeRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "email", required = true)
        @NotNull
        @Size(max = 254)
        @Email
        String email,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "scene", required = true)
        @NotNull
        @Pattern(regexp = "^(?:REGISTER|RESET_PASSWORD)$")
        String scene,
    @Size(max = 64) String captchaId,
    @Size(min = 1, max = 8) String captchaCode) {
  public EmailCodeRequest {
    email = email == null ? null : email.trim().toLowerCase(java.util.Locale.ROOT);
  }
}
