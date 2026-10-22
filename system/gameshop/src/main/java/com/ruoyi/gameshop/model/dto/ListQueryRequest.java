package com.ruoyi.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** Web 查询参数，与 Mapper 条件对象分离。 */
public record ListQueryRequest(
    @Min(1) @Max(100000) Integer pageNum,
    @Min(1) @Max(50) Integer pageSize,
    @Size(max = 80) String keyword,
    String categoryId,
    String memberId,
    String propId,
    String status,
    @Size(max = 40) String orderNo,
    String bizType,
    String sort,
    String minPrice,
    String maxPrice,
    String createdFrom,
    String createdTo) {}
