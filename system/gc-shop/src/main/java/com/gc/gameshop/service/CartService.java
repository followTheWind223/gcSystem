package com.gc.gameshop.service;

import com.gc.gameshop.model.command.*;
import com.gc.gameshop.model.result.CartResult;

public interface CartService {
  CartResult get(Long member);

  CartResult add(Long member, AddCartCommand c);

  CartResult update(Long member, Long id, UpdateCartCommand c);

  CartResult remove(Long member, Long id);

  CartResult select(Long member, SelectCartCommand c);
}
