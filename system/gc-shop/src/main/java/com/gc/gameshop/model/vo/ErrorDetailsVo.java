package com.gc.gameshop.model.vo;

import java.util.List;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record ErrorDetailsVo(
    @com.fasterxml.jackson.annotation.JsonInclude(
            com.fasterxml.jackson.annotation.JsonInclude.Include.NON_NULL)
        List<FieldErrorVo> fieldErrors,
    @com.fasterxml.jackson.annotation.JsonInclude(
            com.fasterxml.jackson.annotation.JsonInclude.Include.NON_NULL)
        List<ItemErrorVo> items,
    @com.fasterxml.jackson.annotation.JsonInclude(
            com.fasterxml.jackson.annotation.JsonInclude.Include.NON_NULL)
        String orderStatus) {}
