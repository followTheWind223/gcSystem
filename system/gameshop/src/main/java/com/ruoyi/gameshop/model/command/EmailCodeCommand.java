package com.ruoyi.gameshop.model.command;

/** Service 业务输入；不作为数据库实体。 */
public record EmailCodeCommand(String email, String scene, String captchaId, String captchaCode) {}
