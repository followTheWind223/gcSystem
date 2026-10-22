package com.gc.gameshop.model.result;

import java.util.List;

/** Service 业务输出；不作为数据库实体。 */
public record CartResult(List<CartItemResult> items, CartSummaryResult summary) {}
