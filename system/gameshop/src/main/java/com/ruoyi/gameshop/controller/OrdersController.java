package com.ruoyi.gameshop.controller;

import static com.ruoyi.gameshop.convert.CommandAssembler.*;
import static com.ruoyi.gameshop.convert.ViewAssembler.*;

import com.ruoyi.gameshop.convert.*;
import com.ruoyi.gameshop.model.dto.*;
import com.ruoyi.gameshop.model.vo.*;
import com.ruoyi.gameshop.security.*;
import com.ruoyi.gameshop.service.*;
import com.ruoyi.gameshop.web.*;
import jakarta.validation.Valid;
import java.io.IOException;
import java.net.URI;
import java.util.*;
import org.springframework.http.*;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@Validated
public class OrdersController {
  private final QuoteService quotes;
  private final OrderService orders;

  public OrdersController(QuoteService quotes, OrderService orders) {
    this.quotes = quotes;
    this.orders = orders;
  }

  private Long mid() {
    return ShopIdentity.member().memberId();
  }

  @PostMapping(value = "/api/mall/order-quotes")
  public ResponseEntity<ApiResponse<OrderPreviewVo>> memberPreviewOrder(
      @Valid @RequestBody OrderPreviewRequest body) throws IOException {
    var result = quotes.preview(mid(), toOrderPreviewCommand(body));
    return ResponseEntity.status(200).body(ApiResponse.ok(toOrderPreviewVo(result)));
  }

  @PostMapping(value = "/api/mall/orders")
  public ResponseEntity<ApiResponse<OrderCreatedVo>> memberCreateOrder(
      @Valid @RequestBody CreateOrderRequest body) throws IOException {
    var result = orders.create(mid(), toCreateOrderCommand(body));
    return ResponseEntity.status(result.replayed() ? 200 : 201)
        .location(URI.create("/api/mall/orders/" + result.order().orderNo()))
        .body(ApiResponse.ok(toOrderCreatedVo(result)));
  }

  @GetMapping(value = "/api/mall/orders")
  public ResponseEntity<PageResponse<OrderSummaryVo>> memberListOrders(
      @Valid @ModelAttribute ListQueryRequest query) throws IOException {
    var page = orders.memberOrders(mid(), QueryAssembler.toQuery(query, false));
    return ResponseEntity.ok(
        new PageResponse<>(
            200,
            "查询成功",
            page.rows().stream().map(ViewAssembler::toOrderSummaryVo).toList(),
            page.total()));
  }

  @GetMapping(value = "/api/mall/orders/{orderNo}")
  public ResponseEntity<ApiResponse<OrderDetailVo>> memberGetOrder(@PathVariable String orderNo)
      throws IOException {
    var result = orders.memberOrder(mid(), orderNo);
    return ResponseEntity.status(200).body(ApiResponse.ok(toOrderDetailVo(result)));
  }

  @PutMapping(value = "/api/mall/orders/{orderNo}/cancellation")
  public ResponseEntity<ApiResponse<OrderDetailVo>> memberCancelOrder(
      @PathVariable String orderNo, @Valid @RequestBody CancelOrderRequest body)
      throws IOException {
    var result = orders.cancel(mid(), orderNo, toCancelOrderCommand(body));
    return ResponseEntity.status(200).body(ApiResponse.ok(toOrderDetailVo(result)));
  }

  @PostMapping(value = "/api/mall/orders/{orderNo}/payments")
  public ResponseEntity<ApiResponse<MockPayResultVo>> memberMockPay(
      @PathVariable String orderNo, @Valid @RequestBody MockPayRequest body) throws IOException {
    var result = orders.pay(mid(), orderNo, toMockPayCommand(body));
    return ResponseEntity.status(200).body(ApiResponse.ok(toMockPayResultVo(result)));
  }
}
