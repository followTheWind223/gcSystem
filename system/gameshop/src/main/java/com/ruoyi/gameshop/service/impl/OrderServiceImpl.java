package com.ruoyi.gameshop.service.impl;

import static com.ruoyi.gameshop.support.ShopValues.*;

import com.fasterxml.jackson.core.type.TypeReference;
import com.ruoyi.gameshop.exception.ShopException;
import com.ruoyi.gameshop.mapper.*;
import com.ruoyi.gameshop.model.bo.*;
import com.ruoyi.gameshop.model.command.*;
import com.ruoyi.gameshop.model.query.ShopQuery;
import com.ruoyi.gameshop.model.result.*;
import com.ruoyi.gameshop.persistence.entity.*;
import com.ruoyi.gameshop.service.*;
import com.ruoyi.gameshop.support.*;
import java.math.BigDecimal;
import java.util.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OrderServiceImpl implements OrderService {
  private final OrderMapper orders;
  private final CatalogMapper catalog;
  private final MemberMapper members;
  private final CartMapper cart;
  private final ReviewMapper reviews;
  private final QuoteService quotes;
  private final MemberService memberService;
  private final ShopJson json;
  private final ShopRedis redis;
  private final GameServerService servers;

  public OrderServiceImpl(
      OrderMapper orders,
      CatalogMapper catalog,
      MemberMapper members,
      CartMapper cart,
      ReviewMapper reviews,
      QuoteService quotes,
      MemberService memberService,
      ShopJson json,
      ShopRedis redis,
      GameServerService servers) {
    this.orders = orders;
    this.catalog = catalog;
    this.members = members;
    this.cart = cart;
    this.reviews = reviews;
    this.quotes = quotes;
    this.memberService = memberService;
    this.json = json;
    this.redis = redis;
    this.servers = servers;
  }

  private String requestKey(String k) {
    try {
      if (k == null
          || !k.matches(
              "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"))
        throw new IllegalArgumentException();
      return UUID.fromString(k).toString();
    } catch (Exception e) {
      throw ShopException.invalid("requestKey 必须为标准 UUID。");
    }
  }

  private Actor memberActor(Long mid) {
    return new Actor("MEMBER", mid, members.findMember(mid).getUsername());
  }

  private void log(OrderEntity o, String old, String reason, Actor a) {
    OrderLogEntity l = new OrderLogEntity();
    l.setOrderId(o.getOrderId());
    l.setFromStatus(old);
    l.setToStatus(o.getStatus());
    l.setOperatorType(a.type());
    l.setOperatorId(a.id());
    l.setOperatorName(a.name());
    l.setReason(reason);
    orders.insertOrderLog(l);
  }

  private StockLogEntity stock(
      PropEntity p,
      int delta,
      String type,
      String key,
      Long order,
      Actor a,
      String reason,
      String requestHash) {
    int before = p.getStock();
    if (catalog.changeStock(p.getPropId(), delta) != 1)
      throw ShopException.conflict("MALL_STOCK_INSUFFICIENT", "库存不足或超出容量。");
    StockLogEntity l = new StockLogEntity();
    l.setPropId(p.getPropId());
    l.setPropName(p.getName());
    l.setChangeQty(delta);
    l.setBeforeStock(before);
    l.setAfterStock(before + delta);
    l.setBizType(type);
    l.setBizKey(key);
    l.setRequestHash(requestHash);
    l.setOrderId(order);
    l.setOperatorType(a.type());
    l.setOperatorId(a.id());
    l.setOperatorName(a.name());
    l.setReason(reason);
    orders.insertStockLog(l);
    p.setStock(before + delta);
    return l;
  }

  @Transactional
  public OrderCreatedResult create(Long mid, CreateOrderCommand c) {
    members.lockMember(mid);
    String key = requestKey(c.requestKey());
    // 旧版三字段交付信息保持原摘要形状，避免升级后旧幂等请求被误判为内容变化。
    Map<String,Object> requestDelivery=new LinkedHashMap<>();
    requestDelivery.put("gameAccount",c.deliveryInfo().gameAccount());
    requestDelivery.put("serverName",c.deliveryInfo().serverName());
    requestDelivery.put("roleName",c.deliveryInfo().roleName());
    if(c.deliveryInfo().serverIds()!=null)requestDelivery.put("serverIds",c.deliveryInfo().serverIds());
    String fingerprint =
        hash(
            json.write(
                List.of(c.quoteToken(), requestDelivery, c.remark() == null ? "" : c.remark())));
    var old = orders.byRequest(mid, key);
    if (old != null) {
      if (!fingerprint.equals(old.getRequestHash()))
        throw ShopException.conflict("MALL_IDEMPOTENCY_CONFLICT", "同一请求键不能更改内容。");
      return new OrderCreatedResult(detail(old), true);
    }
    redis.rate("mall:rate:order:" + mid, 20, 60);
    var q = quotes.load(mid, c.quoteToken());
    Map<Long, PropEntity> products = new TreeMap<>();
    for (var i : q.items()) {
      var p = catalog.findProp(id(i.propId()));
      if (p == null) throw ShopException.conflict("MALL_PROP_UNAVAILABLE", "商品已不可用。");
      products.put(p.getPropId(), p);
    }
    Map<Long, GameCategoryEntity> lockedCategories = new TreeMap<>();
    products.values().stream()
        .map(PropEntity::getCategoryId)
        .distinct()
        .sorted()
        .forEach(cid -> lockedCategories.put(cid, catalog.lockGameCategory(cid)));
    Set<String> fields = new LinkedHashSet<>();
    for (var entry : products.entrySet()) {
      var p = catalog.lockProp(entry.getKey());
      if (!p.getCategoryId().equals(entry.getValue().getCategoryId()))
        throw ShopException.conflict("MALL_QUOTE_CHANGED", "商品分类已变化，请重新预览。");
      var cat = lockedCategories.get(p.getCategoryId());
      if (!"0".equals(p.getDelFlag())
          || !"1".equals(p.getStatus())
          || cat == null
          || !"0".equals(cat.getDelFlag())
          || !"1".equals(cat.getStatus()))
        throw ShopException.conflict("MALL_PROP_UNAVAILABLE", "商品或分类已不可用。");
      entry.setValue(p);
      fields.addAll(json.read(p.getDeliveryFieldsJson(), new TypeReference<List<String>>() {}));
    }
    if (!new LinkedHashSet<>(q.deliveryFields()).equals(fields))
      throw ShopException.conflict("MALL_QUOTE_CHANGED", "交付要求已变化，请重新预览。");
    for (int index = 0; index < q.items().size(); index++) {
      var i = q.items().get(index);
      var p = products.get(id(i.propId()));
      if (p.getPrice().compareTo(new BigDecimal(i.unitPrice())) != 0)
        throw new ShopException(
            409,
            "MALL_QUOTE_CHANGED",
            "商品价格已变化。",
            new ErrorDetailsResult(
                null,
                List.of(
                    new ItemErrorResult(
                        i.propId(),
                        i.cartItemId(),
                        "PRICE_CHANGED",
                        p.getStock(),
                        money(p.getPrice()))),
                null));
      if (p.getStock() < i.quantity())
        throw new ShopException(
            409,
            "MALL_STOCK_INSUFFICIENT",
            "库存不足。",
            new ErrorDetailsResult(
                null,
                List.of(
                    new ItemErrorResult(
                        i.propId(),
                        i.cartItemId(),
                        "OUT_OF_STOCK",
                        p.getStock(),
                        money(p.getPrice()))),
                null));
      if (i.cartItemId() != null) {
        var row = cart.lockCartItem(id(i.cartItemId()));
        if (row == null
            || !mid.equals(row.getMemberId())
            || !row.getPropId().equals(p.getPropId())
            || !row.getQuantity().equals(i.quantity())
            || !time(row.getUpdateTime()).equals(q.cartVersions().get(index)))
          throw ShopException.conflict("MALL_CART_CHANGED", "购物车已变化。");
      }
    }
    DeliveryInfoCommand info = c.deliveryInfo();
    Set<Long> serverGames=new TreeSet<>();
    for(var product:products.values())if(json.read(product.getDeliveryFieldsJson(),new TypeReference<List<String>>(){}).contains("serverName"))serverGames.add(product.getCategoryId());
    var selectedServers=servers.validateSelection(serverGames,info.serverIds(),info.serverName());
    Map<String, Object> delivery = new LinkedHashMap<>();
    delivery.put("gameAccount", clean(info.gameAccount()));
    String serverSummary=selectedServers.isEmpty()?null:selectedServers.size()==1?selectedServers.get(0).serverName():selectedServers.stream().map(s->s.categoryName()+"："+s.serverName()).collect(java.util.stream.Collectors.joining("；"));
    if(serverSummary!=null && serverSummary.length()>100)serverSummary=serverSummary.substring(0,99)+"…";
    delivery.put("serverName", serverSummary);
    delivery.put("roleName", clean(info.roleName()));
    for (String f : fields)
      if (delivery.get(f) == null) throw ShopException.invalid("请填写全部必需交付信息。");
    delivery.put("servers",selectedServers);
    BigDecimal total =
        q.items().stream()
            .map(i -> new BigDecimal(i.subtotal()))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    capacity(total);
    OrderEntity o = new OrderEntity();
    o.setOrderNo(number("GC"));
    o.setMemberId(mid);
    o.setSource(q.source());
    o.setRequestKey(key);
    o.setRequestHash(fingerprint);
    o.setTotalAmount(total);
    o.setTotalQuantity(q.items().stream().mapToInt(QuoteItemResult::quantity).sum());
    o.setItemCount(q.items().size());
    o.setCurrency("CNY");
    o.setStatus("1");
    o.setDeliveryInfoJson(json.write(delivery));
    o.setRemark(clean(c.remark()));
    o.setExpireTime(now().plusMinutes(30));
    orders.insertOrder(o);
    Actor actor = memberActor(mid);
    for (var i : q.items()) {
      var p = products.get(id(i.propId()));
      OrderItemEntity row = new OrderItemEntity();
      row.setOrderId(o.getOrderId());
      row.setPropId(p.getPropId());
      row.setPropName(p.getName());
      row.setCoverUrl(i.coverUrl());
      row.setSpecJson(json.write(i.specs()));
      row.setUnitPrice(p.getPrice());
      row.setQuantity(i.quantity());
      orders.insertOrderItem(row);
      stock(
          p, -i.quantity(), "ORDER_RESERVE", o.getOrderNo(), o.getOrderId(), actor, "下单预留库存", null);
      if (i.cartItemId() != null) cart.remove(id(i.cartItemId()), mid);
    }
    log(o, null, "创建订单", actor);
    return new OrderCreatedResult(detail(orders.findOrder(o.getOrderId())), false);
  }

  private OrderEntity own(Long mid, String no, boolean lock) {
    var o = orders.byNumber(no);
    if (o == null || !mid.equals(o.getMemberId())) throw ShopException.missing();
    return lock ? orders.lockOrder(o.getOrderId()) : o;
  }

  private void statusFilter(ShopQuery q) {
    if (q.status() != null && !Set.of("1", "2", "3", "4").contains(q.status()))
      throw ShopException.invalid("订单状态不合法。");
  }

  private ShopQuery memberQuery(Long mid, ShopQuery q) {
    if (q.memberId() != null && !mid.equals(q.memberId())) throw ShopException.invalid("不能指定他人身份。");
    return new ShopQuery(
        q.offset(),
        q.limit(),
        null,
        null,
        mid,
        null,
        q.status(),
        q.orderNo(),
        null,
        null,
        null,
        null,
        q.createdFrom(),
        q.createdTo(),
        false);
  }

  private List<OrderItemResult> items(OrderEntity o) {
    return orders.items(o.getOrderId()).stream()
        .map(
            i -> {
              var r = reviews.byItem(i.getOrderItemId());
              return new OrderItemResult(
                  id(i.getPropId()),
                  i.getPropName(),
                  i.getCoverUrl(),
                  json.read(i.getSpecJson(), new TypeReference<List<SpecificationResult>>() {}),
                  money(i.getUnitPrice()),
                  i.getQuantity(),
                  money(i.getSubtotal()),
                  id(i.getOrderItemId()),
                  "4".equals(o.getStatus()) && r == null,
                  r == null ? null : id(r.getReviewId()));
            })
        .toList();
  }

  private OrderDetailResult detail(OrderEntity o) {
    var pay = orders.payment(o.getOrderId());
    var delivery = orders.delivery(o.getOrderId());
    var logs =
        orders.logs(o.getOrderId()).stream()
            .map(
                l ->
                    new OrderLogResult(
                        l.getFromStatus(), l.getToStatus(), l.getReason(), time(l.getCreateTime())))
            .toList();
    return new OrderDetailResult(
        id(o.getOrderId()),
        o.getOrderNo(),
        o.getStatus(),
        money(o.getTotalAmount()),
        o.getTotalQuantity(),
        o.getItemCount(),
        o.getCurrency(),
        time(o.getCreateTime()),
        time(o.getExpireTime()),
        time(o.getPaidTime()),
        time(o.getCancelledTime()),
        time(o.getCompletedTime()),
        time(now()),
        "1".equals(o.getStatus()) && now().isBefore(o.getExpireTime()),
        "1".equals(o.getStatus()),
        items(o),
        json.read(o.getDeliveryInfoJson(), DeliveryInfoResult.class),
        o.getRemark(),
        o.getCancelReason(),
        pay == null
            ? null
            : new PaymentResult(
                pay.getPaymentNo(),
                pay.getChannel(),
                money(pay.getAmount()),
                time(pay.getPaidTime())),
        delivery == null
            ? null
            : new DeliveryRecordResult(
                delivery.getDeliveryNote(), time(delivery.getDeliveredTime())),
        logs);
  }

  private OrderSummaryResult summary(OrderEntity o) {
    return new OrderSummaryResult(
        id(o.getOrderId()),
        o.getOrderNo(),
        o.getStatus(),
        money(o.getTotalAmount()),
        o.getTotalQuantity(),
        o.getItemCount(),
        o.getCurrency(),
        time(o.getCreateTime()),
        time(o.getExpireTime()),
        time(o.getPaidTime()),
        time(o.getCancelledTime()),
        time(o.getCompletedTime()),
        time(now()),
        "1".equals(o.getStatus()) && now().isBefore(o.getExpireTime()),
        "1".equals(o.getStatus()),
        items(o));
  }

  public PageResult<OrderSummaryResult> memberOrders(Long mid, ShopQuery q) {
    statusFilter(q);
    var filter = memberQuery(mid, q);
    return new PageResult<>(
        orders.listOrder(filter).stream().map(this::summary).toList(), orders.countOrder(filter));
  }

  public OrderDetailResult memberOrder(Long mid, String no) {
    return detail(own(mid, no, false));
  }

  private void stateError(OrderEntity o) {
    throw new ShopException(
        409,
        "MALL_ORDER_STATE_INVALID",
        "当前订单状态不允许此操作。",
        new ErrorDetailsResult(null, null, o.getStatus()));
  }

  private void cancelLocked(OrderEntity o, String reason, Actor actor) {
    if ("3".equals(o.getStatus())) return;
    if (!"1".equals(o.getStatus())) stateError(o);
    o.setStatus("3");
    o.setCancelReason(reason);
    o.setCancelledTime(now());
    if (orders.transition(o, "1") != 1) stateError(o);
    var rows =
        orders.items(o.getOrderId()).stream()
            .sorted(Comparator.comparing(OrderItemEntity::getPropId))
            .toList();
    for (var i : rows) {
      var p = catalog.lockProp(i.getPropId());
      stock(
          p, i.getQuantity(), "ORDER_RELEASE", o.getOrderNo(), o.getOrderId(), actor, reason, null);
    }
    log(o, "1", reason, actor);
  }

  @Transactional
  public OrderDetailResult cancel(Long mid, String no, CancelOrderCommand c) {
    var o = own(mid, no, true);
    cancelLocked(o, clean(c.reason()) == null ? "会员取消" : clean(c.reason()), memberActor(mid));
    return detail(orders.findOrder(o.getOrderId()));
  }

  @Transactional
  public MockPayResultResult pay(Long mid, String no, MockPayCommand c) {
    var o = own(mid, no, true);
    if (("2".equals(o.getStatus()) || "4".equals(o.getStatus())) && "SUCCESS".equals(c.result())) {
      var p = orders.payment(o.getOrderId());
      return new MockPayResultResult("SUCCESS", detail(o), p.getPaymentNo());
    }
    if (!"1".equals(o.getStatus())) stateError(o);
    if (!now().isBefore(o.getExpireTime()))
      throw ShopException.conflict("MALL_ORDER_EXPIRED", "订单已到期。");
    if ("FAIL".equals(c.result())) return new MockPayResultResult("FAILED", detail(o), null);
    o.setStatus("2");
    o.setPaidTime(now());
    if (orders.transition(o, "1") != 1) stateError(o);
    PaymentRecordEntity p = new PaymentRecordEntity();
    p.setOrderId(o.getOrderId());
    p.setPaymentNo(number("MP"));
    p.setChannel("MOCK");
    p.setAmount(o.getTotalAmount());
    p.setPaidTime(o.getPaidTime());
    orders.insertPaymentRecord(p);
    for (var i :
        orders.items(o.getOrderId()).stream()
            .sorted(Comparator.comparing(OrderItemEntity::getPropId))
            .toList()) {
      catalog.lockProp(i.getPropId());
      if (catalog.addSales(i.getPropId(), i.getQuantity()) != 1)
        throw ShopException.invalid("销量容量不足。");
    }
    log(o, "1", "模拟支付成功", memberActor(mid));
    return new MockPayResultResult(
        "SUCCESS", detail(orders.findOrder(o.getOrderId())), p.getPaymentNo());
  }

  public AdminOrderResult adminOrder(Long oid) {
    var o = orders.findOrder(oid);
    if (o == null) throw ShopException.missing();
    var d = detail(o);
    return new AdminOrderResult(
        d.orderId(),
        d.orderNo(),
        d.status(),
        d.totalAmount(),
        d.totalQuantity(),
        d.itemCount(),
        d.currency(),
        d.createdAt(),
        d.expiresAt(),
        d.paidAt(),
        d.cancelledAt(),
        d.completedAt(),
        d.serverTime(),
        d.canPay(),
        d.canCancel(),
        d.items(),
        d.deliveryInfo(),
        d.remark(),
        d.cancelReason(),
        d.payment(),
        d.delivery(),
        d.logs(),
        memberService.admin(o.getMemberId()));
  }

  public PageResult<AdminOrderResult> adminOrders(ShopQuery q) {
    statusFilter(q);
    return new PageResult<>(
        orders.listOrder(q).stream().map(o -> adminOrder(o.getOrderId())).toList(),
        orders.countOrder(q));
  }

  @Transactional
  public AdminOrderResult adminCancel(Long oid, AdminCancelOrderCommand c, Actor a) {
    var o = orders.lockOrder(oid);
    if (o == null) throw ShopException.missing();
    cancelLocked(o, c.reason().trim(), a);
    return adminOrder(oid);
  }

  @Transactional
  public AdminOrderResult complete(Long oid, CompleteOrderCommand c, Actor a) {
    var o = orders.lockOrder(oid);
    if (o == null) throw ShopException.missing();
    String note = c.deliveryNote().trim();
    if (note.length() < 2) throw ShopException.invalid("交付说明至少2字符。");
    if ("4".equals(o.getStatus())) {
      if (!note.equals(orders.delivery(oid).getDeliveryNote())) stateError(o);
      return adminOrder(oid);
    }
    if (!"2".equals(o.getStatus())) stateError(o);
    o.setStatus("4");
    o.setCompletedTime(now());
    if (orders.transition(o, "2") != 1) stateError(o);
    OrderDeliveryEntity d = new OrderDeliveryEntity();
    d.setOrderId(oid);
    d.setDeliveryNote(note);
    d.setOperatorAdminId(a.id());
    d.setOperatorName(a.name());
    d.setDeliveredTime(o.getCompletedTime());
    orders.insertOrderDelivery(d);
    log(o, "2", "管理员登记道具交付", a);
    return adminOrder(oid);
  }

  @Transactional
  public void expire(Long oid) {
    var o = orders.lockOrder(oid);
    if (o != null && "1".equals(o.getStatus()) && !now().isBefore(o.getExpireTime()))
      cancelLocked(o, "超时未支付自动关闭", Actor.system());
  }

  private StockLogResult stockResult(StockLogEntity l) {
    return new StockLogResult(
        id(l.getStockLogId()),
        id(l.getPropId()),
        l.getPropName(),
        l.getChangeQty(),
        l.getBeforeStock(),
        l.getAfterStock(),
        l.getBizType(),
        l.getBizKey(),
        l.getOperatorType(),
        id(l.getOperatorId()),
        l.getReason(),
        time(l.getCreateTime()));
  }

  @Transactional
  public StockLogResult adjust(Long pid, AdjustStockCommand c, Actor a) {
    var p = catalog.lockProp(pid);
    if (p == null || !"0".equals(p.getDelFlag())) throw ShopException.missing();
    String key = requestKey(c.requestKey());
    String fp = hash(json.write(List.of(pid, a.id(), c.delta(), c.reason().trim())));
    var old = orders.stockByKey(pid, "ADMIN_ADJUST", key);
    if (old != null) {
      if (!fp.equals(old.getRequestHash()))
        throw ShopException.conflict("MALL_IDEMPOTENCY_CONFLICT", "同一库存键不能修改请求。");
      return stockResult(old);
    }
    if (c.delta() == 0) throw ShopException.invalid("库存调整不能为0。");
    // 商品行锁阻止新的预留/回补提交；读取待支付预留时不反向锁订单。
    if (c.delta() > 0
        && (long) p.getStock() + c.delta() + orders.pendingQuantity(pid) > 1000000000L) {
      throw ShopException.invalid("调整后需为待支付订单保留取消回补容量。");
    }
    var l = stock(p, c.delta(), "ADMIN_ADJUST", key, null, a, c.reason().trim(), fp);
    return stockResult(orders.findStockLog(l.getStockLogId()));
  }

  public PageResult<StockLogResult> stockLogs(ShopQuery q) {
    if (q.bizType() != null
        && !Set.of("INITIAL", "ORDER_RESERVE", "ORDER_RELEASE", "ADMIN_ADJUST")
            .contains(q.bizType())) throw ShopException.invalid("库存业务类型不合法。");
    return new PageResult<>(
        orders.listStockLog(q).stream().map(this::stockResult).toList(), orders.countStockLog(q));
  }
}
