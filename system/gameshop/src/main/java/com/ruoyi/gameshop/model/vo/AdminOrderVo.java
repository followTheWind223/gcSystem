package com.ruoyi.gameshop.model.vo;

import java.util.List;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record AdminOrderVo(
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
    List<OrderItemVo> items,
    DeliveryInfoVo deliveryInfo,
    String remark,
    String cancelReason,
    PaymentVo payment,
    DeliveryRecordVo delivery,
    List<OrderLogVo> logs,
    AdminMemberVo member) {}
