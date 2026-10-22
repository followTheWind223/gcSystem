package com.gc.gameshop.security;

import com.gc.common.utils.SecurityUtils;
import com.gc.gameshop.exception.ShopException;
import com.gc.gameshop.model.bo.Actor;
import org.springframework.security.core.context.SecurityContextHolder;

public final class ShopIdentity {
  private ShopIdentity() {}

  public static MemberPrincipal member() {
    var a = SecurityContextHolder.getContext().getAuthentication();
    if (a == null || !(a.getPrincipal() instanceof MemberPrincipal p))
      throw new ShopException(401, "MALL_UNAUTHENTICATED", "请先登录。");
    return p;
  }

  public static Actor admin() {
    return new Actor("ADMIN", SecurityUtils.getUserId(), SecurityUtils.getUsername());
  }

  public static Actor buyer() {
    var p = member();
    return new Actor("MEMBER", p.memberId(), "member:" + p.memberId());
  }
}
