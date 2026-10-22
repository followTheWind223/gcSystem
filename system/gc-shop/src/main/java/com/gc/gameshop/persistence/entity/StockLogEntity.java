package com.gc.gameshop.persistence.entity;

import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class StockLogEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long stockLogId;

  /** 商品关联 */
  private Long propId;

  /** 库存变动时商品名称快照 */
  private String propName;

  /** 本次增减量，初始库存允许 0，库存调整不允许 0 */
  private Integer changeQty;

  /** 变更前库存，必须在锁/原子更新事务中取得 */
  private Integer beforeStock;

  /** 变更后库存，必须等于 before_stock+change_qty */
  private Integer afterStock;

  /** INITIAL/ORDER_RESERVE/ORDER_RELEASE/ADMIN_ADJUST */
  private String bizType;

  /** INITIAL=商品 ID；订单类=orderNo；调整=requestKey */
  private String bizKey;

  /** ADMIN_ADJUST 时必填，摘要包含 propId/operatorId/delta/reason；其他类型可空 */
  private String requestHash;

  /** 订单扣减/回补时必填，初始和人工调整为 null */
  private Long orderId;

  /** ADMIN、MEMBER、SYSTEM，多态操作者类型 */
  private String operatorType;

  /** 按类型逻辑关联 sys_user 或 mall_member；SYSTEM 必须 null */
  private Long operatorId;

  /** 账号快照；SYSTEM 使用 system */
  private String operatorName;

  /** 库存变动或人工调整原因 */
  private String reason;

  /** 变动时间 */
  private LocalDateTime createTime;

  public Long getStockLogId() {
    return stockLogId;
  }

  public void setStockLogId(Long value) {
    this.stockLogId = value;
  }

  public Long getPropId() {
    return propId;
  }

  public void setPropId(Long value) {
    this.propId = value;
  }

  public String getPropName() {
    return propName;
  }

  public void setPropName(String value) {
    this.propName = value;
  }

  public Integer getChangeQty() {
    return changeQty;
  }

  public void setChangeQty(Integer value) {
    this.changeQty = value;
  }

  public Integer getBeforeStock() {
    return beforeStock;
  }

  public void setBeforeStock(Integer value) {
    this.beforeStock = value;
  }

  public Integer getAfterStock() {
    return afterStock;
  }

  public void setAfterStock(Integer value) {
    this.afterStock = value;
  }

  public String getBizType() {
    return bizType;
  }

  public void setBizType(String value) {
    this.bizType = value;
  }

  public String getBizKey() {
    return bizKey;
  }

  public void setBizKey(String value) {
    this.bizKey = value;
  }

  public String getRequestHash() {
    return requestHash;
  }

  public void setRequestHash(String value) {
    this.requestHash = value;
  }

  public Long getOrderId() {
    return orderId;
  }

  public void setOrderId(Long value) {
    this.orderId = value;
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
