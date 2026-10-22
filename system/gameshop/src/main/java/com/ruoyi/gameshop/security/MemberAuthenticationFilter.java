package com.ruoyi.gameshop.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.gameshop.exception.ShopException;
import com.ruoyi.gameshop.support.*;
import com.ruoyi.gameshop.web.ApiError;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

public class MemberAuthenticationFilter extends OncePerRequestFilter {
  private final com.ruoyi.framework.web.service.TokenService tokens;
  private final com.ruoyi.gameshop.service.impl.RuoyiMemberService members;
  private final ShopRedis redis;
  private final ObjectMapper json;

  public MemberAuthenticationFilter(com.ruoyi.framework.web.service.TokenService tokens,
      com.ruoyi.gameshop.service.impl.RuoyiMemberService members, ShopRedis redis, ObjectMapper json) {
    this.tokens = tokens;
    this.members = members;
    this.redis = redis;
    this.json = json;
  }

  @Override
  protected void doFilterInternal(
      HttpServletRequest req, HttpServletResponse res, FilterChain chain)
      throws ServletException, IOException {
    try {
      boolean pub = isPublic(req);
      String ip = ShopValues.hash(req.getRemoteAddr());
      if (pub) redis.rate("mall:rate:public:" + ip, 120, 60);
      else {
        String auth = req.getHeader("Authorization");
        if (auth == null || !auth.startsWith("Bearer "))
          throw new ShopException(401, "MALL_UNAUTHENTICATED", "请先登录。");
        var user = tokens.getLoginUser(req);
        if (user == null) throw new ShopException(401, "MALL_UNAUTHENTICATED", "登录已失效，请重新登录。");
        tokens.verifyToken(user);
        var member = members.resolve(user.getUserId());
        var p = new MemberPrincipal(member.getMemberId(), member.getSessionVersion(), user.getToken());
        redis.rate("mall:rate:member:" + p.memberId(), 120, 60);
        SecurityContextHolder.getContext()
            .setAuthentication(new UsernamePasswordAuthenticationToken(p, null, List.of()));
      }
      chain.doFilter(req, res);
    } catch (ShopException e) {
      res.setStatus(e.getStatus());
      res.setContentType("application/json;charset=UTF-8");
      if (e.getStatus() == 429) res.setHeader("Retry-After", "60");
      if (e.getStatus() == 401) res.setHeader("WWW-Authenticate", "Bearer");
      json.writeValue(
          res.getWriter(), new ApiError(e.getStatus(), e.getMessage(), e.getErrorCode(), null));
    } finally {
      SecurityContextHolder.clearContext();
    }
  }

  public static boolean isPublic(HttpServletRequest r) {
    String p = r.getRequestURI(), m = r.getMethod();
    return "OPTIONS".equals(m)
        || ("GET".equals(m)
            && (p.equals("/api/mall/home")
                || p.equals("/api/mall/categories")
                || p.startsWith("/api/mall/props")
                || p.startsWith("/api/mall/media/")));
  }
}
