package com.gc.gameshop.model.command;

/** Service 业务输入；不作为数据库实体。 */
public record DeliveryInfoCommand(String gameAccount, String serverName, String roleName, java.util.List<String> serverIds) {}
