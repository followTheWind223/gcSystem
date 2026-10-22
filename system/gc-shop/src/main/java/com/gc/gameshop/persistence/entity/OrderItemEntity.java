package com.gc.gameshop.persistence.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class OrderItemEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long orderItemId;

  /** 所属订单 */
  private Long orderId;

  /** 商品历史关联；软删除后仍保留 */
  private Long propId;

  /** 下单时商品名称快照，不随改名变更 */
  private String propName;

  /** 下单时受控图片 URL 快照 */
  private String coverUrl;

  /** 下单时展示规格快照 */
  private String specJson;

  /** 下单时真实单价，不随调价变更 */
  private BigDecimal unitPrice;

  /** 1–99，合并后的购买数量 */
  private Integer quantity;

  /** 数据库生成列；INSERT/UPDATE 不允许赋值；服务端还需检查总额容量 */
  private BigDecimal subtotal;

  /** 快照创建时间 */
  private LocalDateTime createTime;

  public Long getOrderItemId() {
    return orderItemId;
  }

  public void setOrderItemId(Long value) {
    this.orderItemId = value;
  }

  public Long getOrderId() {
    return orderId;
  }

  public void setOrderId(Long value) {
    this.orderId = value;
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

  public String getCoverUrl() {
    return coverUrl;
  }

  public void setCoverUrl(String value) {
    this.coverUrl = value;
  }

  public String getSpecJson() {
    return specJson;
  }

  public void setSpecJson(String value) {
    this.specJson = value;
  }

  public BigDecimal getUnitPrice() {
    return unitPrice;
  }

  public void setUnitPrice(BigDecimal value) {
    this.unitPrice = value;
  }

  public Integer getQuantity() {
    return quantity;
  }

  public void setQuantity(Integer value) {
    this.quantity = value;
  }

  public BigDecimal getSubtotal() {
    return subtotal;
  }

  public void setSubtotal(BigDecimal value) {
    this.subtotal = value;
  }

  public LocalDateTime getCreateTime() {
    return createTime;
  }

  public void setCreateTime(LocalDateTime value) {
    this.createTime = value;
  }
}
