package com.gc.gameshop.service;

import com.gc.gameshop.model.bo.QuoteSnapshot;
import com.gc.gameshop.model.command.OrderPreviewCommand;
import com.gc.gameshop.model.result.OrderPreviewResult;

public interface QuoteService {
  OrderPreviewResult preview(Long member, OrderPreviewCommand command);

  QuoteSnapshot load(Long member, String token);
}
