package com.ruoyi.gameshop.model.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record CreateOrderRequest(
    @com.fasterxml.jackson.annotation.JsonProperty(value = "requestKey", required = true) @NotNull
        String requestKey,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "quoteToken", required = true)
        @NotNull
        @Size(min = 16, max = 2048)
        String quoteToken,
    @com.fasterxml.jackson.annotation.JsonProperty(value = "deliveryInfo", required = true)
        @NotNull
        @Valid
        DeliveryInfo deliveryInfo,
    @Size(max = 200) String remark) {}
