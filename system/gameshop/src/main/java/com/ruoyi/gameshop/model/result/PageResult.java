package com.ruoyi.gameshop.model.result;

import java.util.List;

public record PageResult<T>(List<T> rows, long total) {}
