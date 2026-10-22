package com.gc.gameshop.controller;

import static com.gc.gameshop.convert.CommandAssembler.*;
import static com.gc.gameshop.convert.ViewAssembler.*;
import static com.gc.gameshop.support.ShopValues.id;

import com.gc.common.annotation.Log;
import com.gc.common.enums.BusinessType;
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
public class AdminOrdersController {
  private final OrderService orders;

  public AdminOrdersController(OrderService orders) {
    this.orders = orders;
  }

  @GetMapping(value = "/mall/orders")
  @PreAuthorize("@ss.hasPermi('mall:order:list')")
  public ResponseEntity<PageResponse<AdminOrderVo>> adminListOrders(
      @Valid @ModelAttribute ListQueryRequest query) throws IOException {
    var page = orders.adminOrders(QueryAssembler.toQuery(query, false));
    return ResponseEntity.ok(
        new PageResponse<>(
            200,
            "查询成功",
            page.rows().stream().map(ViewAssembler::toAdminOrderVo).toList(),
            page.total()));
  }

  @GetMapping(value = "/mall/orders/{orderId}")
  @PreAuthorize("@ss.hasPermi('mall:order:query')")
  public ResponseEntity<ApiResponse<AdminOrderVo>> adminGetOrder(@PathVariable String orderId)
      throws IOException {
    var result = orders.adminOrder(id(orderId));
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminOrderVo(result)));
  }

  @PutMapping(value = "/mall/orders/{orderId}/cancellation")
  @PreAuthorize("@ss.hasPermi('mall:order:cancel')")
  @Log(
      title = "商城：后台取消待支付订单",
      businessType = BusinessType.UPDATE,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<AdminOrderVo>> adminCancelOrder(
      @PathVariable String orderId, @Valid @RequestBody AdminCancelOrderRequest body)
      throws IOException {
    var result =
        orders.adminCancel(id(orderId), toAdminCancelOrderCommand(body), ShopIdentity.admin());
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminOrderVo(result)));
  }

  @PutMapping(value = "/mall/orders/{orderId}/delivery")
  @PreAuthorize("@ss.hasPermi('mall:order:complete')")
  @Log(
      title = "商城：后台登记交付并完成订单",
      businessType = BusinessType.UPDATE,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<AdminOrderVo>> adminCompleteOrder(
      @PathVariable String orderId, @Valid @RequestBody CompleteOrderRequest body)
      throws IOException {
    var result = orders.complete(id(orderId), toCompleteOrderCommand(body), ShopIdentity.admin());
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminOrderVo(result)));
  }
}
