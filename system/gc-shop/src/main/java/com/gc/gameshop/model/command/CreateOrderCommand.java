package com.gc.gameshop.model.command;

/** Service 业务输入；不作为数据库实体。 */
public record CreateOrderCommand(
    String requestKey, String quoteToken, DeliveryInfoCommand deliveryInfo, String remark) {}
