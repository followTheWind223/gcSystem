package com.gc.gameshop.persistence.entity;

import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class OrderLogEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long logId;

  /** 所属订单 */
  private Long orderId;

  /** 初始建单为 null，否则是本次动作的旧状态 */
  private String fromStatus;

  /** 本次动作后的新状态 */
  private String toStatus;

  /** ADMIN、MEMBER、SYSTEM，多态操作者类型 */
  private String operatorType;

  /** 按类型逻辑关联 sys_user 或 mall_member；SYSTEM 必须 null */
  private Long operatorId;

  /** 账号快照；SYSTEM 使用 system */
  private String operatorName;

  /** 动作说明；完整交付说明存交付表，取消原因同时存订单快照 */
  private String reason;

  /** 状态变化时间 */
  private LocalDateTime createTime;

  public Long getLogId() {
    return logId;
  }

  public void setLogId(Long value) {
    this.logId = value;
  }

  public Long getOrderId() {
    return orderId;
  }

  public void setOrderId(Long value) {
    this.orderId = value;
  }

  public String getFromStatus() {
    return fromStatus;
  }

  public void setFromStatus(String value) {
    this.fromStatus = value;
  }

  public String getToStatus() {
    return toStatus;
  }

  public void setToStatus(String value) {
    this.toStatus = value;
  }

  public String getOperatorType() {
    return operatorType;
  }

  public void setOperatorType(String value) {
    this.operatorType = value;
  }

  public Long getOperatorId() {
    return operatorId;
  }

  public void setOperatorId(Long value) {
    this.operatorId = value;
  }

  public String getOperatorName() {
    return operatorName;
  }

  public void setOperatorName(String value) {
    this.operatorName = value;
  }

  public String getReason() {
    return reason;
  }

  public void setReason(String value) {
    this.reason = value;
  }

  public LocalDateTime getCreateTime() {
    return createTime;
  }

  public void setCreateTime(LocalDateTime value) {
    this.createTime = value;
  }
}
