package com.gc.gameshop.model.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import java.util.List;

public record OrderPreviewRequest(
    @NotNull @Pattern(regexp = "DIRECT|CART") String source,
    @Valid @Size(min = 1, max = 1) List<CheckoutItemRequest> items,
    @Size(min = 1, max = 50) List<String> cartItemIds) {}
