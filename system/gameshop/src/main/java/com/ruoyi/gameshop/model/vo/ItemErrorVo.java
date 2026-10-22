package com.ruoyi.gameshop.model.vo;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record ItemErrorVo(
    String propId,
    @com.fasterxml.jackson.annotation.JsonInclude(
            com.fasterxml.jackson.annotation.JsonInclude.Include.NON_NULL)
        String cartItemId,
    String reason,
    @com.fasterxml.jackson.annotation.JsonInclude(
            com.fasterxml.jackson.annotation.JsonInclude.Include.NON_NULL)
        Integer availableStock,
    @com.fasterxml.jackson.annotation.JsonInclude(
            com.fasterxml.jackson.annotation.JsonInclude.Include.NON_NULL)
        String currentUnitPrice) {}
