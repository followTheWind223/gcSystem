package com.gc.gameshop.model.bo;

import com.gc.gameshop.model.result.QuoteItemResult;
import java.util.List;

public record QuoteSnapshot(
    Long memberId,
    String source,
    List<QuoteItemResult> items,
    List<String> deliveryFields,
    List<String> cartVersions) {}
