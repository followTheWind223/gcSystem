package com.gc.gameshop.controller;

import static com.gc.gameshop.convert.CommandAssembler.*;
import static com.gc.gameshop.convert.ViewAssembler.*;

import com.gc.gameshop.convert.*;
import com.gc.gameshop.model.dto.*;
import com.gc.gameshop.model.vo.*;
import com.gc.gameshop.security.*;
import com.gc.gameshop.service.*;
import com.gc.gameshop.web.*;
import jakarta.validation.Valid;
import java.io.IOException;
import java.util.*;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@Validated
public class AdminStockController {
  private final OrderService orders;

  public AdminStockController(OrderService orders) {
    this.orders = orders;
  }

  @GetMapping(value = "/mall/stock-logs")
  @PreAuthorize("@ss.hasPermi('mall:stock:list')")
  public ResponseEntity<PageResponse<StockLogVo>> adminListStockLogs(
      @Valid @ModelAttribute ListQueryRequest query) throws IOException {
    var page = orders.stockLogs(QueryAssembler.toQuery(query, false));
    return ResponseEntity.ok(
        new PageResponse<>(
            200,
            "查询成功",
            page.rows().stream().map(ViewAssembler::toStockLogVo).toList(),
            page.total()));
  }
}
