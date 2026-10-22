package com.gc.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record CaptchaResult(
    Boolean captchaEnabled, String captchaId, String imageBase64, Integer expiresInSeconds,
    Boolean emailVerificationEnabled) {}
