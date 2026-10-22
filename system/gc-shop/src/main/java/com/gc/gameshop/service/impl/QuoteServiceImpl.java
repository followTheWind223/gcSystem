package com.gc.gameshop.service.impl;

import static com.gc.gameshop.support.ShopValues.*;

import com.fasterxml.jackson.core.type.TypeReference;
import com.gc.gameshop.exception.ShopException;
import com.gc.gameshop.mapper.*;
import com.gc.gameshop.model.bo.*;
import com.gc.gameshop.model.command.*;
import com.gc.gameshop.model.result.*;
import com.gc.gameshop.persistence.entity.*;
import com.gc.gameshop.service.*;
import com.gc.gameshop.support.*;
import java.math.BigDecimal;
import java.util.*;
import org.springframework.stereotype.Service;

@Service
public class QuoteServiceImpl implements QuoteService {
  private final CatalogMapper catalog;
  private final CartMapper cart;
  private final MediaService media;
  private final ShopRedis redis;
  private final ShopJson json;
  private final GameServerService servers;

  public QuoteServiceImpl(
      CatalogMapper catalog, CartMapper cart, MediaService media, ShopRedis redis, ShopJson json, GameServerService servers) {
    this.catalog = catalog;
    this.cart = cart;
    this.media = media;
    this.redis = redis;
    this.json = json;
    this.servers = servers;
  }

  public OrderPreviewResult preview(Long mid, OrderPreviewCommand c) {
    List<QuoteItemResult> items = new ArrayList<>();
    List<String> versions = new ArrayList<>();
    Set<String> delivery = new LinkedHashSet<>();
    if ("DIRECT".equals(c.source())) {
      if (c.items() == null || c.items().size() != 1 || c.cartItemIds() != null)
        throw ShopException.invalid("DIRECT 仅接受一个items商品。");
      var i = c.items().get(0);
      items.add(item(id(i.propId()), null, i.quantity(), delivery));
    } else if ("CART".equals(c.source())) {
      if (c.items() != null
          || c.cartItemIds() == null
          || c.cartItemIds().isEmpty()
          || c.cartItemIds().size() > 50) throw ShopException.invalid("CART 需显式选择1至50条购物车项。");
      unique(c.cartItemIds());
      for (String sid : c.cartItemIds()) {
        var i = cart.findCartItem(id(sid));
        if (i == null || !mid.equals(i.getMemberId())) throw ShopException.missing();
        items.add(item(i.getPropId(), i.getCartItemId(), i.getQuantity(), delivery));
        versions.add(time(i.getUpdateTime()));
      }
    } else throw ShopException.invalid("报价来源不合法。");
    BigDecimal total =
        items.stream()
            .map(i -> new BigDecimal(i.subtotal()))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    capacity(total);
    String token = random();
    var snapshot = new QuoteSnapshot(mid, c.source(), items, List.copyOf(delivery), versions);
    redis.put("mall:quote:" + mid + ":" + hash(token), json.write(snapshot), 300);
    Set<Long> gameIds=new TreeSet<>();
    for(var item:items){
      var product=catalog.findProp(id(item.propId()));
      if(json.read(product.getDeliveryFieldsJson(),new TypeReference<List<String>>(){}).contains("serverName"))gameIds.add(product.getCategoryId());
    }
    return new OrderPreviewResult(
        token,
        time(now().plusMinutes(5)),
        c.source(),
        items,
        money(total),
        items.stream().mapToInt(QuoteItemResult::quantity).sum(),
        "CNY",
        List.copyOf(delivery),
        time(now()),
        servers.groups(gameIds));
  }

  private QuoteItemResult item(Long pid, Long cid, int quantity, Set<String> delivery) {
    if (quantity < 1 || quantity > 99) throw ShopException.invalid("数量应为1至99。");
    var p = catalog.findProp(pid);
    var cat = p == null ? null : catalog.findGameCategory(p.getCategoryId());
    if (p == null
        || !"0".equals(p.getDelFlag())
        || !"1".equals(p.getStatus())
        || cat == null
        || !"0".equals(cat.getDelFlag())
        || !"1".equals(cat.getStatus()))
      throw ShopException.conflict("MALL_PROP_UNAVAILABLE", "商品不可购买。");
    if (p.getStock() < quantity)
      throw new ShopException(
          409,
          "MALL_STOCK_INSUFFICIENT",
          "库存不足。",
          new ErrorDetailsResult(
              null,
              List.of(
                  new ItemErrorResult(
                      id(pid), id(cid), "OUT_OF_STOCK", p.getStock(), money(p.getPrice()))),
              null));
    delivery.addAll(json.read(p.getDeliveryFieldsJson(), new TypeReference<List<String>>() {}));
    var specs = json.read(p.getSpecJson(), new TypeReference<List<SpecificationResult>>() {});
    return new QuoteItemResult(
        id(pid),
        id(cid),
        p.getName(),
        media.url(p.getCoverMediaId()),
        specs,
        money(p.getPrice()),
        quantity,
        money(p.getPrice().multiply(BigDecimal.valueOf(quantity))),
        p.getStock());
  }

  public QuoteSnapshot load(Long mid, String token) {
    String raw = redis.get("mall:quote:" + mid + ":" + hash(token));
    if (raw == null) throw ShopException.conflict("MALL_QUOTE_EXPIRED", "报价已过期，请重新确认。");
    var q = json.read(raw, QuoteSnapshot.class);
    if (!mid.equals(q.memberId())) throw ShopException.conflict("MALL_QUOTE_EXPIRED", "报价无效。");
    return q;
  }
}
