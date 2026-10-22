package com.gc.gameshop.model.dto;
import jakarta.validation.constraints.*;
public record ListGameServersRequest(@Min(1) @Max(100000) Integer pageNum, @Min(1) @Max(50) Integer pageSize,
    @Size(max=80) String keyword, @Pattern(regexp="^[1-9][0-9]{0,18}$") String categoryId, @Pattern(regexp="^[01]$") String status) {}

