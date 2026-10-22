package com.ruoyi.gameshop.task;

import com.ruoyi.gameshop.mapper.OrderMapper;
import com.ruoyi.gameshop.service.OrderService;
import org.springframework.stereotype.Component;

/** 每笔订单独立事务；服务重启后会补扫已到期记录。 */
@Component("gameshopOrderExpiry")
public class OrderExpiryTask {
  private final OrderMapper mapper;
  private final OrderService service;

  public OrderExpiryTask(OrderMapper mapper, OrderService service) {
    this.mapper = mapper;
    this.service = service;
  }

  public void closeExpired() {
    for (Long id : mapper.expiredIds())
      try {
        service.expire(id);
      } catch (RuntimeException e) {
        org.slf4j.LoggerFactory.getLogger(getClass())
            .warn("关闭到期订单失败，orderId={}，异常类型={}", id, e.getClass().getSimpleName());
      }
  }
}
