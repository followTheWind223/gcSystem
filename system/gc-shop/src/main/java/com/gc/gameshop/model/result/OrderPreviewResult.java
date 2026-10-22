package com.gc.gameshop.model.result;

import java.util.List;

/** Service 业务输出；不作为数据库实体。 */
public record OrderPreviewResult(
    String quoteToken,
    String quoteExpiresAt,
    String source,
    List<QuoteItemResult> items,
    String totalAmount,
    Integer totalQuantity,
    String currency,
    List<String> deliveryFields,
    String serverTime,
    List<GameServerGroupResult> serverGroups) {}
