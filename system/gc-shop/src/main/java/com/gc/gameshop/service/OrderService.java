package com.gc.gameshop.service;

import com.gc.gameshop.model.bo.Actor;
import com.gc.gameshop.model.command.*;
import com.gc.gameshop.model.query.ShopQuery;
import com.gc.gameshop.model.result.*;

public interface OrderService {
  OrderCreatedResult create(Long member, CreateOrderCommand command);

  PageResult<OrderSummaryResult> memberOrders(Long member, ShopQuery query);

  OrderDetailResult memberOrder(Long member, String number);

  OrderDetailResult cancel(Long member, String number, CancelOrderCommand command);

  MockPayResultResult pay(Long member, String number, MockPayCommand command);

  PageResult<AdminOrderResult> adminOrders(ShopQuery query);

  AdminOrderResult adminOrder(Long id);

  AdminOrderResult adminCancel(Long id, AdminCancelOrderCommand command, Actor actor);

  AdminOrderResult complete(Long id, CompleteOrderCommand command, Actor actor);

  void expire(Long id);

  StockLogResult adjust(Long propId, AdjustStockCommand command, Actor actor);

  PageResult<StockLogResult> stockLogs(ShopQuery query);
}
