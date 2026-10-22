package com.ruoyi.gameshop.persistence.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class OrderEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long orderId;

  /** 服务器生成的 16–40 位大写字母数字订单号，全局唯一 */
  private String orderNo;

  /** 下单会员，构成订单归属；从认证上下文取得 */
  private Long memberId;

  /** DIRECT 或 CART，来自报价快照 */
  private String source;

  /** 规范化小写 UUID；同会员同键永不重复建单 */
  private String requestKey;

  /** 规范化 quoteToken/交付字段/备注的 SHA-256，仅用于精确重放，不保存原始令牌 */
  private String requestHash;

  /** 各明细 subtotal 之和，大于 0，由服务端计算 */
  private BigDecimal totalAmount;

  /** 各明细数量之和，1–4950 */
  private Integer totalQuantity;

  /** 不同商品明细行数，1–50 */
  private Integer itemCount;

  /** 首版固定人民币 */
  private String currency;

  /** 1 待支付，2 已支付，3 已取消，4 已完成 */
  private String status;

  /** 本单交付信息快照，三字段可空：gameAccount/serverName/roleName；禁止存游戏密码 */
  private String deliveryInfoJson;

  /** 买家备注，trim 后空白归 null */
  private String remark;

  /** 取消原因，取消状态必填 */
  private String cancelReason;

  /** 创建后默认 30 分钟，过期不可支付 */
  private LocalDateTime expireTime;

  /** 首次成功支付时间 */
  private LocalDateTime paidTime;

  /** 实际取消/关单时间 */
  private LocalDateTime cancelledTime;

  /** 登记交付并完成的时间 */
  private LocalDateTime completedTime;

  /** 记录创建时间，数据库会话为 +08:00 */
  private LocalDateTime createTime;

  /** 记录最近修改时间；更新行时由数据库刷新 */
  private LocalDateTime updateTime;

  public Long getOrderId() {
    return orderId;
  }

  public void setOrderId(Long value) {
    this.orderId = value;
  }

  public String getOrderNo() {
    return orderNo;
  }

  public void setOrderNo(String value) {
    this.orderNo = value;
  }

  public Long getMemberId() {
    return memberId;
  }

  public void setMemberId(Long value) {
    this.memberId = value;
  }

  public String getSource() {
    return source;
  }

  public void setSource(String value) {
    this.source = value;
  }

  public String getRequestKey() {
    return requestKey;
  }

  public void setRequestKey(String value) {
    this.requestKey = value;
  }

  public String getRequestHash() {
    return requestHash;
  }

  public void setRequestHash(String value) {
    this.requestHash = value;
  }

  public BigDecimal getTotalAmount() {
    return totalAmount;
  }

  public void setTotalAmount(BigDecimal value) {
    this.totalAmount = value;
  }

  public Integer getTotalQuantity() {
    return totalQuantity;
  }

  public void setTotalQuantity(Integer value) {
    this.totalQuantity = value;
  }

  public Integer getItemCount() {
    return itemCount;
  }

  public void setItemCount(Integer value) {
    this.itemCount = value;
  }

  public String getCurrency() {
    return currency;
  }

  public void setCurrency(String value) {
    this.currency = value;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String value) {
    this.status = value;
  }

  public String getDeliveryInfoJson() {
    return deliveryInfoJson;
  }

  public void setDeliveryInfoJson(String value) {
    this.deliveryInfoJson = value;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String value) {
    this.remark = value;
  }

  public String getCancelReason() {
    return cancelReason;
  }

  public void setCancelReason(String value) {
    this.cancelReason = value;
  }

  public LocalDateTime getExpireTime() {
    return expireTime;
  }

  public void setExpireTime(LocalDateTime value) {
    this.expireTime = value;
  }

  public LocalDateTime getPaidTime() {
    return paidTime;
  }

  public void setPaidTime(LocalDateTime value) {
    this.paidTime = value;
  }

  public LocalDateTime getCancelledTime() {
    return cancelledTime;
  }

  public void setCancelledTime(LocalDateTime value) {
    this.cancelledTime = value;
  }

  public LocalDateTime getCompletedTime() {
    return completedTime;
  }

  public void setCompletedTime(LocalDateTime value) {
    this.completedTime = value;
  }

  public LocalDateTime getCreateTime() {
    return createTime;
  }

  public void setCreateTime(LocalDateTime value) {
    this.createTime = value;
  }

  public LocalDateTime getUpdateTime() {
    return updateTime;
  }

  public void setUpdateTime(LocalDateTime value) {
    this.updateTime = value;
  }
}
