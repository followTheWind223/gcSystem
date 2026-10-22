package com.ruoyi.gameshop.persistence.entity;

/** Mapper 关联游戏名称的查询行，与 HTTP 返回类分离。 */
public class GameServerRow extends GameServerEntity {
  private String categoryName;
  public String getCategoryName() { return categoryName; }
  public void setCategoryName(String value) { categoryName=value; }
}

