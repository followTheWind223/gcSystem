package com.gc.gameshop.model.command;

/** Service 业务输入；不作为数据库实体。 */
public record LoginCommand(
    String username, String password, String captchaId, String captchaCode) {}
