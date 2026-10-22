package com.ruoyi.gameshop.web;

import java.util.List;

public record PageResponse<T>(int code, String msg, List<T> rows, long total) {}
