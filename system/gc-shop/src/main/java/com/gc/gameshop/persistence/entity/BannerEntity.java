package com.gc.gameshop.persistence.entity;

import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class BannerEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long bannerId;

  /** 1–60 字符标题 */
  private String title;

  /** 轮播图媒体 */
  private Long imageMediaId;

  /** 内部目标商品，不允许任意外链 */
  private Long targetPropId;

  /** 0–9999 排序值 */
  private Integer sort;

  /** 0 停用/下架，1 启用/上架 */
  private String status;

  /** 乐观锁版本；插入为 0，每次合法修改递增；库存操作也递增商品版本 */
  private Integer version;

  /** 0 正常，2 软删除；公开查询必须过滤为 0 */
  private String delFlag;

  /** 记录创建时间，数据库会话为 +08:00 */
  private LocalDateTime createTime;

  /** 记录最近修改时间；更新行时由数据库刷新 */
  private LocalDateTime updateTime;

  /** 创建操作者账号快照，不作为鉴权依据 */
  private String createBy;

  /** 最后修改操作者账号快照 */
  private String updateBy;

  public Long getBannerId() {
    return bannerId;
  }

  public void setBannerId(Long value) {
    this.bannerId = value;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String value) {
    this.title = value;
  }

  public Long getImageMediaId() {
    return imageMediaId;
  }

  public void setImageMediaId(Long value) {
    this.imageMediaId = value;
  }

  public Long getTargetPropId() {
    return targetPropId;
  }

  public void setTargetPropId(Long value) {
    this.targetPropId = value;
  }

  public Integer getSort() {
    return sort;
  }

  public void setSort(Integer value) {
    this.sort = value;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String value) {
    this.status = value;
  }

  public Integer getVersion() {
    return version;
  }

  public void setVersion(Integer value) {
    this.version = value;
  }

  public String getDelFlag() {
    return delFlag;
  }

  public void setDelFlag(String value) {
    this.delFlag = value;
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

  public String getCreateBy() {
    return createBy;
  }

  public void setCreateBy(String value) {
    this.createBy = value;
  }

  public String getUpdateBy() {
    return updateBy;
  }

  public void setUpdateBy(String value) {
    this.updateBy = value;
  }
}
