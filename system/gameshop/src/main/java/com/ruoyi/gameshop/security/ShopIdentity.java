package com.ruoyi.gameshop.security;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.gameshop.exception.ShopException;
import com.ruoyi.gameshop.model.bo.Actor;
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
