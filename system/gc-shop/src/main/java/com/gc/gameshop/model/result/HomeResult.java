package com.gc.gameshop.model.result;

import java.util.List;

/** Service 业务输出；不作为数据库实体。 */
public record HomeResult(
    List<BannerResult> banners,
    List<CategoryResult> hotCategories,
    List<PropSummaryResult> hotProps,
    String serverTime) {}
