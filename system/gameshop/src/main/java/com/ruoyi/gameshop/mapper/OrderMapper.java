package com.ruoyi.gameshop.mapper;

import com.ruoyi.gameshop.model.query.ShopQuery;
import com.ruoyi.gameshop.persistence.entity.*;
import java.util.List;
import org.apache.ibatis.annotations.*;

@Mapper
public interface OrderMapper {
  OrderEntity findOrder(@Param("id") Long id);

  OrderEntity lockOrder(@Param("id") Long id);

  int insertOrder(OrderEntity row);

  OrderItemEntity findOrderItem(@Param("id") Long id);

  OrderItemEntity lockOrderItem(@Param("id") Long id);

  int insertOrderItem(OrderItemEntity row);

  PaymentRecordEntity findPaymentRecord(@Param("id") Long id);

  PaymentRecordEntity lockPaymentRecord(@Param("id") Long id);

  int insertPaymentRecord(PaymentRecordEntity row);

  OrderDeliveryEntity findOrderDelivery(@Param("id") Long id);

  OrderDeliveryEntity lockOrderDelivery(@Param("id") Long id);

  int insertOrderDelivery(OrderDeliveryEntity row);

  OrderLogEntity findOrderLog(@Param("id") Long id);

  OrderLogEntity lockOrderLog(@Param("id") Long id);

  int insertOrderLog(OrderLogEntity row);

  StockLogEntity findStockLog(@Param("id") Long id);

  StockLogEntity lockStockLog(@Param("id") Long id);

  int insertStockLog(StockLogEntity row);

  OrderEntity byNumber(@Param("number") String number);

  OrderEntity byRequest(@Param("memberId") Long memberId, @Param("key") String key);

  List<OrderItemEntity> items(@Param("id") Long id);

  PaymentRecordEntity payment(@Param("id") Long id);

  OrderDeliveryEntity delivery(@Param("id") Long id);

  List<OrderLogEntity> logs(@Param("id") Long id);

  StockLogEntity stockByKey(
      @Param("propId") Long propId, @Param("type") String type, @Param("key") String key);

  int transition(@Param("row") OrderEntity row, @Param("old") String old);

  List<Long> expiredIds();

  List<OrderEntity> listOrder(ShopQuery query);

  long countOrder(ShopQuery query);

  List<StockLogEntity> listStockLog(ShopQuery query);

  long countStockLog(ShopQuery query);

  long pendingQuantity(@Param("propId") Long propId);
}
