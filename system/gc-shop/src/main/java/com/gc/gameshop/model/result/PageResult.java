package com.gc.gameshop.model.result;

import java.util.List;

public record PageResult<T>(List<T> rows, long total) {}
