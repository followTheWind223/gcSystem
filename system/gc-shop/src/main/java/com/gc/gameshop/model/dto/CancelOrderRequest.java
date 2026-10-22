package com.gc.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record CancelOrderRequest(@Size(max = 200) String reason) {}
