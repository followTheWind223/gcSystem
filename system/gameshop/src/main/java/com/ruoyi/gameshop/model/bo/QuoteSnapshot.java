package com.ruoyi.gameshop.model.bo;

import com.ruoyi.gameshop.model.result.QuoteItemResult;
import java.util.List;

public record QuoteSnapshot(
    Long memberId,
    String source,
    List<QuoteItemResult> items,
    List<String> deliveryFields,
    List<String> cartVersions) {}
