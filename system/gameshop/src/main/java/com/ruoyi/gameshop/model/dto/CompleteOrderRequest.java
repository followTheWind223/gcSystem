package com.ruoyi.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record CompleteOrderRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "deliveryNote", required = true)
        @NotNull
        @Size(min = 2, max = 1000)
        String deliveryNote) {}
