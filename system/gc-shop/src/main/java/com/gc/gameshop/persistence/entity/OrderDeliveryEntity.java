package com.gc.gameshop.persistence.entity;

import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class OrderDeliveryEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long deliveryId;

  /** 所属订单，一单至多一次完成交付 */
  private Long orderId;

  /** 2–1000 字符交付说明，购买会员可见，禁止游戏密码 */
  private String deliveryNote;

  /** 后台操作者 ID，逻辑关联 sys_user；从认证上下文取得 */
  private Long operatorAdminId;

  /** 操作者账号快照，防止后台账号后来删除导致历史丢失 */
  private String operatorName;

  /** 交付完成时间，与订单 completed_time 同值 */
  private LocalDateTime deliveredTime;

  /** 记录落库时间 */
  private LocalDateTime createTime;

  public Long getDeliveryId() {
    return deliveryId;
  }

  public void setDeliveryId(Long value) {
    this.deliveryId = value;
  }

  public Long getOrderId() {
    return orderId;
  }

  public void setOrderId(Long value) {
    this.orderId = value;
  }

  public String getDeliveryNote() {
    return deliveryNote;
  }

  public void setDeliveryNote(String value) {
    this.deliveryNote = value;
  }

  public Long getOperatorAdminId() {
    return operatorAdminId;
  }

  public void setOperatorAdminId(Long value) {
    this.operatorAdminId = value;
  }

  public String getOperatorName() {
    return operatorName;
  }

  public void setOperatorName(String value) {
    this.operatorName = value;
  }

  public LocalDateTime getDeliveredTime() {
    return deliveredTime;
  }

  public void setDeliveredTime(LocalDateTime value) {
    this.deliveredTime = value;
  }

  public LocalDateTime getCreateTime() {
    return createTime;
  }

  public void setCreateTime(LocalDateTime value) {
    this.createTime = value;
  }
}
