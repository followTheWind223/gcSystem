package com.ruoyi.gameshop.persistence.entity;

import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class GameCategoryEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long categoryId;

  /** trim 后 2–30 字符；未删除分类中名称按 utf8mb4_unicode_ci 唯一 */
  private String name;

  /** 分类图标，可空 */
  private Long iconMediaId;

  /** 展示排序，0–9999，较小在前 */
  private Integer sort;

  /** 0 停用/下架，1 启用/上架 */
  private String status;

  /** 0 普通，1 首页热门推荐 */
  private Integer recommended;

  /** 乐观锁版本；插入为 0，每次合法修改递增；库存操作也递增商品版本 */
  private Integer version;

  /** 0 正常，2 软删除；公开查询必须过滤为 0 */
  private String delFlag;

  /** 仅未删除行生成名称；软删除行生成 NULL，允许删除后重建同名分类 */
  private String activeName;

  /** 记录创建时间，数据库会话为 +08:00 */
  private LocalDateTime createTime;

  /** 记录最近修改时间；更新行时由数据库刷新 */
  private LocalDateTime updateTime;

  /** 创建操作者账号快照，不作为鉴权依据 */
  private String createBy;

  /** 最后修改操作者账号快照 */
  private String updateBy;

  public Long getCategoryId() {
    return categoryId;
  }

  public void setCategoryId(Long value) {
    this.categoryId = value;
  }

  public String getName() {
    return name;
  }

  public void setName(String value) {
    this.name = value;
  }

  public Long getIconMediaId() {
    return iconMediaId;
  }

  public void setIconMediaId(Long value) {
    this.iconMediaId = value;
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

  public Integer getRecommended() {
    return recommended;
  }

  public void setRecommended(Integer value) {
    this.recommended = value;
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

  public String getActiveName() {
    return activeName;
  }

  public void setActiveName(String value) {
    this.activeName = value;
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
