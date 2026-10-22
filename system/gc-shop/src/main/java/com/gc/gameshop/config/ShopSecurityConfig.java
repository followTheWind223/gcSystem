package com.gc.gameshop.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.gc.framework.security.filter.JwtAuthenticationTokenFilter;
import com.gc.gameshop.security.*;
import com.gc.gameshop.support.ShopRedis;
import com.gc.gameshop.web.ApiError;
import org.springframework.context.annotation.*;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.*;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.filter.CorsFilter;

@Configuration
public class ShopSecurityConfig {
  @Bean
  org.springframework.boot.web.servlet.FilterRegistrationBean<JwtAuthenticationTokenFilter>
      jwtServletRegistration(JwtAuthenticationTokenFilter jwt) {
    var registration = new org.springframework.boot.web.servlet.FilterRegistrationBean<>(jwt);
    registration.setEnabled(false);
    return registration;
  }

  @Bean
  @Order(1)
  SecurityFilterChain memberChain(
      HttpSecurity h,
      com.gc.framework.web.service.TokenService tokens,
      com.gc.gameshop.service.impl.RuoyiMemberService members,
      ShopRedis redis,
      ObjectMapper json,
      CorsFilter cors)
      throws Exception {
    return h.securityMatcher("/api/mall/**")
        .csrf(c -> c.disable())
        .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .authorizeHttpRequests(a -> a.anyRequest().permitAll())
        .addFilterBefore(
            new MemberAuthenticationFilter(tokens, members, redis, json),
            UsernamePasswordAuthenticationFilter.class)
        .addFilterBefore(cors, UsernamePasswordAuthenticationFilter.class)
        .build();
  }

  @Bean
  @Order(2)
  SecurityFilterChain mallAdminChain(
      HttpSecurity h, JwtAuthenticationTokenFilter jwt, ObjectMapper json, CorsFilter cors)
      throws Exception {
    return h.securityMatcher("/mall/**")
        .csrf(c -> c.disable())
        .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .authorizeHttpRequests(a -> a.anyRequest().access((authentication, context) ->
            new org.springframework.security.authorization.AuthorizationDecision(
                com.gc.framework.security.BackofficeAccess.allowed(authentication.get()))))
        .exceptionHandling(
            e ->
                e.authenticationEntryPoint(
                        (req, res, ex) -> {
                          res.setStatus(401);
                          res.setContentType("application/json;charset=UTF-8");
                          res.setHeader("WWW-Authenticate", "Bearer");
                          json.writeValue(
                              res.getWriter(),
                              new ApiError(401, "请使用后台身份登录。", "MALL_UNAUTHENTICATED", null));
                        })
                    .accessDeniedHandler(
                        (req, res, ex) -> {
                          res.setStatus(403);
                          res.setContentType("application/json;charset=UTF-8");
                          json.writeValue(
                              res.getWriter(),
                              new ApiError(403, "缺少接口权限。", "MALL_FORBIDDEN", null));
                        }))
        .addFilterBefore(jwt, UsernamePasswordAuthenticationFilter.class)
        .addFilterBefore(cors, UsernamePasswordAuthenticationFilter.class)
        .build();
  }
}
