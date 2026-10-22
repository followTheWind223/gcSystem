package com.ruoyi.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record PaymentVo(String paymentNo, String channel, String amount, String paidAt) {}
