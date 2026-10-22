package com.gc.gameshop.model.query;

import java.math.BigDecimal;
import java.time.*;

/** Service -> Mapper 的查询条件；不承担 HTTP 参数绑定。 */
public record ShopQuery(
    int offset,
    int limit,
    String keyword,
    Long categoryId,
    Long memberId,
    Long propId,
    String status,
    String orderNo,
    String bizType,
    String sort,
    BigDecimal minPrice,
    BigDecimal maxPrice,
    LocalDateTime createdFrom,
    LocalDateTime createdTo,
    boolean publicOnly) {}
