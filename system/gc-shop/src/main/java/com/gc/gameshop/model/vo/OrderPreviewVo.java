package com.gc.gameshop.model.vo;

import java.util.List;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record OrderPreviewVo(
    String quoteToken,
    String quoteExpiresAt,
    String source,
    List<QuoteItemVo> items,
    String totalAmount,
    Integer totalQuantity,
    String currency,
    List<String> deliveryFields,
    String serverTime,
    List<GameServerGroupVo> serverGroups) {}
