package com.gc.gameshop.model.query;
public record GameServerQuery(int offset, int limit, String keyword, Long categoryId, String status) {}

