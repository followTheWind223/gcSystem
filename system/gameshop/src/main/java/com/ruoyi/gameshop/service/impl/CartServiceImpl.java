package com.ruoyi.gameshop.service.impl;

import static com.ruoyi.gameshop.support.ShopValues.*;

import com.ruoyi.gameshop.exception.ShopException;
import com.ruoyi.gameshop.mapper.*;
import com.ruoyi.gameshop.model.command.*;
import com.ruoyi.gameshop.model.result.*;
import com.ruoyi.gameshop.persistence.entity.*;
import com.ruoyi.gameshop.service.*;
import java.math.BigDecimal;
import java.util.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CartServiceImpl implements CartService {
  private final CartMapper cart;
  private final CatalogMapper catalog;
  private final MemberMapper members;
  private final MediaService media;

  public CartServiceImpl(
      CartMapper cart, CatalogMapper catalog, MemberMapper members, MediaService media) {
    this.cart = cart;
    this.catalog = catalog;
    this.members = members;
    this.media = media;
  }

  private String availability(PropEntity p, int quantity) {
    if (p == null || !"0".equals(p.getDelFlag())) return "DELETED";
    var c = catalog.findGameCategory(p.getCategoryId());
    if (c == null || !"0".equals(c.getDelFlag()) || !"1".equals(c.getStatus()))
      return "CATEGORY_DISABLED";
    if (!"1".equals(p.getStatus())) return "OFF_SHELF";
    return p.getStock() < quantity ? "OUT_OF_STOCK" : "AVAILABLE";
  }

  private void purchasable(PropEntity p, int quantity) {
    String a = availability(p, quantity);
    if (!a.equals("AVAILABLE"))
      throw ShopException.conflict(
          a.equals("OUT_OF_STOCK") ? "MALL_STOCK_INSUFFICIENT" : "MALL_PROP_UNAVAILABLE",
          "商品状态或库存不满足购买要求。");
  }

  public CartResult get(Long mid) {
    List<CartItemResult> items =
        cart.items(mid).stream()
            .map(
                i -> {
                  var p = catalog.findProp(i.getPropId());
                  var c = p == null ? null : catalog.findGameCategory(p.getCategoryId());
                  String a = availability(p, i.getQuantity());
                  boolean ok = "AVAILABLE".equals(a);
                  return new CartItemResult(
                      id(i.getCartItemId()),
                      id(i.getPropId()),
                      p == null ? "已移除商品" : p.getName(),
                      c == null ? null : c.getName(),
                      p == null ? null : media.url(p.getCoverMediaId()),
                      p == null ? null : money(p.getPrice()),
                      i.getQuantity(),
                      i.getChecked() == 1,
                      p == null ? 0 : p.getStock(),
                      a,
                      ok,
                      ok ? money(p.getPrice().multiply(BigDecimal.valueOf(i.getQuantity()))) : null,
                      time(i.getUpdateTime()));
                })
            .toList();
    var selected = items.stream().filter(i -> i.checked() && i.canCheckout()).toList();
    BigDecimal amount =
        selected.stream()
            .map(i -> new BigDecimal(i.subtotal()))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    return new CartResult(
        items,
        new CartSummaryResult(
            items.size(),
            items.stream().mapToInt(CartItemResult::quantity).sum(),
            selected.size(),
            selected.stream().mapToInt(CartItemResult::quantity).sum(),
            money(amount),
            Math.toIntExact(items.stream().filter(i -> !i.canCheckout()).count())));
  }

  @Transactional
  public CartResult add(Long mid, AddCartCommand c) {
    members.lockMember(mid);
    var p = catalog.lockProp(id(c.propId()));
    var existing = cart.byProp(mid, id(c.propId()));
    int qty = c.quantity() + (existing == null ? 0 : existing.getQuantity());
    if (qty > 99) throw ShopException.conflict("MALL_QUANTITY_EXCEEDED", "合并数量不能超过99。");
    purchasable(p, qty);
    if (existing == null) {
      if (cart.items(mid).size() >= 100)
        throw ShopException.conflict("MALL_CART_LIMIT_EXCEEDED", "购物车最多100种商品。");
      existing = new CartItemEntity();
      existing.setMemberId(mid);
      existing.setPropId(id(c.propId()));
      existing.setQuantity(qty);
      existing.setChecked(1);
      cart.insertCartItem(existing);
    } else {
      existing.setQuantity(qty);
      existing.setChecked(1);
      cart.update(existing);
    }
    return get(mid);
  }

  private CartItemEntity own(Long mid, Long iid) {
    var i = cart.lockCartItem(iid);
    if (i == null || !mid.equals(i.getMemberId())) throw ShopException.missing();
    return i;
  }

  @Transactional
  public CartResult update(Long mid, Long iid, UpdateCartCommand c) {
    members.lockMember(mid);
    var i = own(mid, iid);
    if (c.quantity() > i.getQuantity() || (c.checked() && i.getChecked() == 0))
      purchasable(catalog.lockProp(i.getPropId()), c.quantity());
    i.setQuantity(c.quantity());
    i.setChecked(c.checked() ? 1 : 0);
    cart.update(i);
    return get(mid);
  }

  @Transactional
  public CartResult remove(Long mid, Long iid) {
    members.lockMember(mid);
    cart.remove(iid, mid);
    return get(mid);
  }

  @Transactional
  public CartResult select(Long mid, SelectCartCommand c) {
    members.lockMember(mid);
    unique(c.cartItemIds());
    var items =
        c.cartItemIds().stream()
            .map(com.ruoyi.gameshop.support.ShopValues::id)
            .sorted()
            .map(i -> own(mid, i))
            .toList();
    for (var i : items) {
      i.setChecked(c.checked() ? 1 : 0);
      cart.update(i);
    }
    return get(mid);
  }
}
