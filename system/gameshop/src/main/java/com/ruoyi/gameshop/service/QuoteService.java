package com.ruoyi.gameshop.service;

import com.ruoyi.gameshop.model.bo.QuoteSnapshot;
import com.ruoyi.gameshop.model.command.OrderPreviewCommand;
import com.ruoyi.gameshop.model.result.OrderPreviewResult;

public interface QuoteService {
  OrderPreviewResult preview(Long member, OrderPreviewCommand command);

  QuoteSnapshot load(Long member, String token);
}
