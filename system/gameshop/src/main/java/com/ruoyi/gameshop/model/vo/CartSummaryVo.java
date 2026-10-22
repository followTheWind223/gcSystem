package com.ruoyi.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record CartSummaryVo(
    Integer totalItemCount,
    Integer totalQuantity,
    Integer selectedItemCount,
    Integer selectedQuantity,
    String selectedAmount,
    Integer invalidItemCount) {}
