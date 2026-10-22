package com.gc.gameshop.model.command;

import java.util.List;

public record OrderPreviewCommand(
    String source, List<CheckoutItemCommand> items, List<String> cartItemIds) {}
