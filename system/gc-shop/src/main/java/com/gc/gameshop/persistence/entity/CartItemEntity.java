package com.gc.gameshop.persistence.entity;

import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class CartItemEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long cartItemId;

  /** 会员归属，只从认证上下文取得 */
  private Long memberId;

  /** 关联商品，失效时仍保留购物车行 */
  private Long propId;

  /** 1–99，POST 是增量，PUT 是绝对值 */
  private Integer quantity;

  /** 0 未勾选，1 勾选；不是结算的隐式范围 */
  private Integer checked;

  /** 记录创建时间，数据库会话为 +08:00 */
  private LocalDateTime createTime;

  /** 记录最近修改时间；更新行时由数据库刷新 */
  private LocalDateTime updateTime;

  public Long getCartItemId() {
    return cartItemId;
  }

  public void setCartItemId(Long value) {
    this.cartItemId = value;
  }

  public Long getMemberId() {
    return memberId;
  }

  public void setMemberId(Long value) {
    this.memberId = value;
  }

  public Long getPropId() {
    return propId;
  }

  public void setPropId(Long value) {
    this.propId = value;
  }

  public Integer getQuantity() {
    return quantity;
  }

  public void setQuantity(Integer value) {
    this.quantity = value;
  }

  public Integer getChecked() {
    return checked;
  }

  public void setChecked(Integer value) {
    this.checked = value;
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
