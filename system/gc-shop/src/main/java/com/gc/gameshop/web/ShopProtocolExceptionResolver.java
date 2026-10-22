package com.gc.gameshop.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.*;
import org.springframework.core.Ordered;
import org.springframework.stereotype.Component;
import org.springframework.web.*;
import org.springframework.web.servlet.*;
import org.springframework.web.servlet.resource.NoResourceFoundException;

/** 在尚未选中 Controller 的协议错误阶段保留商城真实 HTTP 状态。 */
@Component
public class ShopProtocolExceptionResolver implements HandlerExceptionResolver, Ordered {
  private final ObjectMapper json;

  public ShopProtocolExceptionResolver(ObjectMapper json) {
    this.json = json;
  }

  @Override
  public int getOrder() {
    return Ordered.HIGHEST_PRECEDENCE;
  }

  @Override
  public ModelAndView resolveException(
      HttpServletRequest request,
      HttpServletResponse response,
      Object handler,
      Exception exception) {
    String path = request.getRequestURI();
    if (!path.startsWith("/api/mall/") && !path.startsWith("/mall/")) return null;
    int status;
    String code, message;
    if (exception instanceof HttpRequestMethodNotSupportedException e) {
      status = 405;
      code = "MALL_METHOD_NOT_ALLOWED";
      message = "该资源不支持此 HTTP 方法。";
      if (e.getSupportedHttpMethods() != null)
        response.setHeader(
            "Allow",
            String.join(", ", e.getSupportedHttpMethods().stream().map(Object::toString).toList()));
    } else if (exception instanceof HttpMediaTypeNotSupportedException) {
      status = 415;
      code = "MALL_CONTENT_TYPE_UNSUPPORTED";
      message = "请求 Content-Type 不受支持。";
    } else if (exception instanceof HttpMediaTypeNotAcceptableException) {
      status = 406;
      code = "MALL_RESPONSE_TYPE_UNSUPPORTED";
      message = "资源不能提供所要求的响应格式。";
    } else if (exception instanceof NoResourceFoundException
        || exception instanceof NoHandlerFoundException) {
      status = 404;
      code = "MALL_RESOURCE_NOT_FOUND";
      message = "资源不存在。";
    } else return null;
    try {
      response.setStatus(status);
      response.setContentType("application/json;charset=UTF-8");
      json.writeValue(response.getWriter(), new ApiError(status, message, code, null));
      return new ModelAndView();
    } catch (java.io.IOException e) {
      return null;
    }
  }
}
