package com.ruoyi.gameshop.persistence.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class PaymentRecordEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long paymentId;

  /** 所属订单，一个订单至多一条成功支付 */
  private Long orderId;

  /** 全局唯一成功支付编号 */
  private String paymentNo;

  /** 首版仅 MOCK */
  private String channel;

  /** 与订单快照金额相等，由支付事务校验 */
  private BigDecimal amount;

  /** 成功支付发生时间，与订单 paid_time 同值 */
  private LocalDateTime paidTime;

  /** 事实落库时间 */
  private LocalDateTime createTime;

  public Long getPaymentId() {
    return paymentId;
  }

  public void setPaymentId(Long value) {
    this.paymentId = value;
  }

  public Long getOrderId() {
    return orderId;
  }

  public void setOrderId(Long value) {
    this.orderId = value;
  }

  public String getPaymentNo() {
    return paymentNo;
  }

  public void setPaymentNo(String value) {
    this.paymentNo = value;
  }

  public String getChannel() {
    return channel;
  }

  public void setChannel(String value) {
    this.channel = value;
  }

  public BigDecimal getAmount() {
    return amount;
  }

  public void setAmount(BigDecimal value) {
    this.amount = value;
  }

  public LocalDateTime getPaidTime() {
    return paidTime;
  }

  public void setPaidTime(LocalDateTime value) {
    this.paidTime = value;
  }

  public LocalDateTime getCreateTime() {
    return createTime;
  }

  public void setCreateTime(LocalDateTime value) {
    this.createTime = value;
  }
}
