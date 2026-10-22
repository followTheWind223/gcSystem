package com.ruoyi.gameshop.model.result;

import java.util.List;

/** Service 业务输出；不作为数据库实体。 */
public record ErrorDetailsResult(
    List<FieldErrorResult> fieldErrors, List<ItemErrorResult> items, String orderStatus) {}
