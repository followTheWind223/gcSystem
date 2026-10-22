package com.gc.gameshop.model.result;

import java.util.List;

/** Service 业务输出；不作为数据库实体。 */
public record OrderSummaryResult(
    String orderId,
    String orderNo,
    String status,
    String totalAmount,
    Integer totalQuantity,
    Integer itemCount,
    String currency,
    String createdAt,
    String expiresAt,
    String paidAt,
    String cancelledAt,
    String completedAt,
    String serverTime,
    Boolean canPay,
    Boolean canCancel,
    List<OrderItemResult> items) {}
