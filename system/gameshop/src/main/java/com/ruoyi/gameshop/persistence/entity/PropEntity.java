package com.ruoyi.gameshop.persistence.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class PropEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long propId;

  /** 所属分类，写入时必须是未删除分类 */
  private Long categoryId;

  /** 商品名称，2–80 字符 */
  private String name;

  /** 封面媒体，服务层保证也在图片列表中 */
  private Long coverMediaId;

  /** 当前售价，大于 0；接口两位小数字符串 */
  private BigDecimal price;

  /** 可空划线价，非空时不小于售价 */
  private BigDecimal originalPrice;

  /** 当前可售库存，0–1000000000；下单扣减，取消回补，支付不再扣 */
  private Integer stock;

  /** 成功支付的累计数量，只在首次支付成功时增加 */
  private Integer sales;

  /** 清洗后的富文本，最多 20000 字符；MEDIUMTEXT 可容纳 utf8mb4 的完整字符容量 */
  private String detailHtml;

  /** 最多 20 个 {name,value} 展示规格，不是 SKU */
  private String specJson;

  /** 1–3 个唯一字段名：gameAccount/serverName/roleName；枚举由服务层校验 */
  private String deliveryFieldsJson;

  /** 0 停用/下架，1 启用/上架 */
  private String status;

  /** 最近一次上架时间；从未上架可空，上架时必须有值 */
  private LocalDateTime onSaleTime;

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

  public Long getPropId() {
    return propId;
  }

  public void setPropId(Long value) {
    this.propId = value;
  }

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

  public Long getCoverMediaId() {
    return coverMediaId;
  }

  public void setCoverMediaId(Long value) {
    this.coverMediaId = value;
  }

  public BigDecimal getPrice() {
    return price;
  }

  public void setPrice(BigDecimal value) {
    this.price = value;
  }

  public BigDecimal getOriginalPrice() {
    return originalPrice;
  }

  public void setOriginalPrice(BigDecimal value) {
    this.originalPrice = value;
  }

  public Integer getStock() {
    return stock;
  }

  public void setStock(Integer value) {
    this.stock = value;
  }

  public Integer getSales() {
    return sales;
  }

  public void setSales(Integer value) {
    this.sales = value;
  }

  public String getDetailHtml() {
    return detailHtml;
  }

  public void setDetailHtml(String value) {
    this.detailHtml = value;
  }

  public String getSpecJson() {
    return specJson;
  }

  public void setSpecJson(String value) {
    this.specJson = value;
  }

  public String getDeliveryFieldsJson() {
    return deliveryFieldsJson;
  }

  public void setDeliveryFieldsJson(String value) {
    this.deliveryFieldsJson = value;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String value) {
    this.status = value;
  }

  public LocalDateTime getOnSaleTime() {
    return onSaleTime;
  }

  public void setOnSaleTime(LocalDateTime value) {
    this.onSaleTime = value;
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
