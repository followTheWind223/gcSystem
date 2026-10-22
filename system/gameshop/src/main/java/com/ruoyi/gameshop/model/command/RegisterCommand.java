package com.ruoyi.gameshop.model.command;

/** Service 业务输入；不作为数据库实体。 */
public record RegisterCommand(
    String username, String password, String nickname, String email, String emailCode,
    String captchaId, String captchaCode) {}
