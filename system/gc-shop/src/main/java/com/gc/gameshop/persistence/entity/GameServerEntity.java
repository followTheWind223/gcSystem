package com.gc.gameshop.persistence.entity;

/** 仅持久化使用的游戏区服实体。 */
public class GameServerEntity {
  private Long serverId;
  private Long categoryId;
  private String name;
  private Integer sort;
  private String status;
  private String remark;
  private Integer version;
  private String delFlag;
  private java.time.LocalDateTime createTime;
  private java.time.LocalDateTime updateTime;
  private String createBy;
  private String updateBy;
  public Long getServerId() { return serverId; }
  public void setServerId(Long value) { this.serverId=value; }
  public Long getCategoryId() { return categoryId; }
  public void setCategoryId(Long value) { this.categoryId=value; }
  public String getName() { return name; }
  public void setName(String value) { this.name=value; }
  public Integer getSort() { return sort; }
  public void setSort(Integer value) { this.sort=value; }
  public String getStatus() { return status; }
  public void setStatus(String value) { this.status=value; }
  public String getRemark() { return remark; }
  public void setRemark(String value) { this.remark=value; }
  public Integer getVersion() { return version; }
  public void setVersion(Integer value) { this.version=value; }
  public String getDelFlag() { return delFlag; }
  public void setDelFlag(String value) { this.delFlag=value; }
  public java.time.LocalDateTime getCreateTime() { return createTime; }
  public void setCreateTime(java.time.LocalDateTime value) { this.createTime=value; }
  public java.time.LocalDateTime getUpdateTime() { return updateTime; }
  public void setUpdateTime(java.time.LocalDateTime value) { this.updateTime=value; }
  public String getCreateBy() { return createBy; }
  public void setCreateBy(String value) { this.createBy=value; }
  public String getUpdateBy() { return updateBy; }
  public void setUpdateBy(String value) { this.updateBy=value; }
}

