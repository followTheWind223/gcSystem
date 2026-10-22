package com.ruoyi.gameshop.controller;

import static com.ruoyi.gameshop.convert.CommandAssembler.*;
import static com.ruoyi.gameshop.convert.ViewAssembler.*;
import static com.ruoyi.gameshop.support.ShopValues.id;

import com.ruoyi.gameshop.convert.*;
import com.ruoyi.gameshop.model.dto.*;
import com.ruoyi.gameshop.model.vo.*;
import com.ruoyi.gameshop.security.*;
import com.ruoyi.gameshop.service.*;
import com.ruoyi.gameshop.web.*;
import jakarta.validation.Valid;
import java.io.IOException;
import java.util.*;
import org.springframework.http.*;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@Validated
public class CartController {
  private final CartService cart;

  public CartController(CartService cart) {
    this.cart = cart;
  }

  private Long mid() {
    return ShopIdentity.member().memberId();
  }

  @GetMapping(value = "/api/mall/cart/items")
  public ResponseEntity<ApiResponse<CartVo>> memberGetCart() throws IOException {
    var result = cart.get(mid());
    return ResponseEntity.status(200).body(ApiResponse.ok(toCartVo(result)));
  }

  @PostMapping(value = "/api/mall/cart/items")
  public ResponseEntity<ApiResponse<CartVo>> memberAddCartItem(
      @Valid @RequestBody AddCartRequest body) throws IOException {
    var result = cart.add(mid(), toAddCartCommand(body));
    return ResponseEntity.status(200).body(ApiResponse.ok(toCartVo(result)));
  }

  @PutMapping(value = "/api/mall/cart/items/{cartItemId}")
  public ResponseEntity<ApiResponse<CartVo>> memberUpdateCartItem(
      @PathVariable String cartItemId, @Valid @RequestBody UpdateCartRequest body)
      throws IOException {
    var result = cart.update(mid(), id(cartItemId), toUpdateCartCommand(body));
    return ResponseEntity.status(200).body(ApiResponse.ok(toCartVo(result)));
  }

  @DeleteMapping(value = "/api/mall/cart/items/{cartItemId}")
  public ResponseEntity<ApiResponse<CartVo>> memberDeleteCartItem(@PathVariable String cartItemId)
      throws IOException {
    var result = cart.remove(mid(), id(cartItemId));
    return ResponseEntity.status(200).body(ApiResponse.ok(toCartVo(result)));
  }

  @PutMapping(value = "/api/mall/cart/selection")
  public ResponseEntity<ApiResponse<CartVo>> memberSelectCartItems(
      @Valid @RequestBody SelectCartRequest body) throws IOException {
    var result = cart.select(mid(), toSelectCartCommand(body));
    return ResponseEntity.status(200).body(ApiResponse.ok(toCartVo(result)));
  }
}
