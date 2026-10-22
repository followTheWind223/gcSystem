package com.gc.gameshop.persistence.entity;

import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class ReviewEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long reviewId;

  /** 评价会员，与订单归属组成复合外键 */
  private Long memberId;

  /** 订单关联 */
  private Long orderId;

  /** 唯一被评价明细，隐藏也不释放唯一约束 */
  private Long orderItemId;

  /** 商品关联，与明细组合外键保证一致 */
  private Long propId;

  /** 1–5 整数评分 */
  private Integer score;

  /** 5–1000 字符纯文本，不解析 HTML */
  private String content;

  /** VISIBLE 或 HIDDEN */
  private String status;

  /** 隐藏原因，隐藏时必填 */
  private String hideReason;

  /** 隐藏操作者后台 ID，逻辑关联 sys_user */
  private Long hiddenBy;

  /** 隐藏时间 */
  private LocalDateTime hiddenTime;

  /** 记录创建时间，数据库会话为 +08:00 */
  private LocalDateTime createTime;

  /** 记录最近修改时间；更新行时由数据库刷新 */
  private LocalDateTime updateTime;

  public Long getReviewId() {
    return reviewId;
  }

  public void setReviewId(Long value) {
    this.reviewId = value;
  }

  public Long getMemberId() {
    return memberId;
  }

  public void setMemberId(Long value) {
    this.memberId = value;
  }

  public Long getOrderId() {
    return orderId;
  }

  public void setOrderId(Long value) {
    this.orderId = value;
  }

  public Long getOrderItemId() {
    return orderItemId;
  }

  public void setOrderItemId(Long value) {
    this.orderItemId = value;
  }

  public Long getPropId() {
    return propId;
  }

  public void setPropId(Long value) {
    this.propId = value;
  }

  public Integer getScore() {
    return score;
  }

  public void setScore(Integer value) {
    this.score = value;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String value) {
    this.content = value;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String value) {
    this.status = value;
  }

  public String getHideReason() {
    return hideReason;
  }

  public void setHideReason(String value) {
    this.hideReason = value;
  }

  public Long getHiddenBy() {
    return hiddenBy;
  }

  public void setHiddenBy(Long value) {
    this.hiddenBy = value;
  }

  public LocalDateTime getHiddenTime() {
    return hiddenTime;
  }

  public void setHiddenTime(LocalDateTime value) {
    this.hiddenTime = value;
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
