package com.gc.gameshop.model.vo;

import java.util.List;

/** HTTP 响应允许字段；不作为数据库实体。 */
public record HomeVo(
    List<BannerVo> banners,
    List<CategoryVo> hotCategories,
    List<PropSummaryVo> hotProps,
    String serverTime) {}
