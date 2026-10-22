package com.ruoyi.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record MockPayResultResult(String outcome, OrderDetailResult order, String paymentNo) {}
