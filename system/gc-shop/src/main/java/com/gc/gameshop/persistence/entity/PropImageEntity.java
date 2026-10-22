package com.gc.gameshop.persistence.entity;

import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class PropImageEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long imageId;

  /** 所属商品 */
  private Long propId;

  /** 图片媒体 */
  private Long mediaId;

  /** 0–9999，同排序时 image_id 升序 */
  private Integer sort;

  /** 关联创建时间 */
  private LocalDateTime createTime;

  public Long getImageId() {
    return imageId;
  }

  public void setImageId(Long value) {
    this.imageId = value;
  }

  public Long getPropId() {
    return propId;
  }

  public void setPropId(Long value) {
    this.propId = value;
  }

  public Long getMediaId() {
    return mediaId;
  }

  public void setMediaId(Long value) {
    this.mediaId = value;
  }

  public Integer getSort() {
    return sort;
  }

  public void setSort(Integer value) {
    this.sort = value;
  }

  public LocalDateTime getCreateTime() {
    return createTime;
  }

  public void setCreateTime(LocalDateTime value) {
    this.createTime = value;
  }
}
