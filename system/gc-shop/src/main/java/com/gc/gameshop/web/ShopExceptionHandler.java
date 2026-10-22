package com.gc.gameshop.web;

import com.gc.gameshop.convert.ViewAssembler;
import com.gc.gameshop.exception.ShopException;
import com.gc.gameshop.model.result.*;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.dao.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

@Order(Ordered.HIGHEST_PRECEDENCE)
@RestControllerAdvice(basePackages = "com.gc.gameshop.controller")
public class ShopExceptionHandler {
  @ExceptionHandler(ShopException.class)
  public ResponseEntity<ApiError> business(ShopException e) {
    var b = ResponseEntity.status(e.getStatus());
    if (e.getStatus() == 429) b.header("Retry-After", "60");
    if (e.getStatus() == 401) b.header("WWW-Authenticate", "Bearer");
    return b.body(
        new ApiError(
            e.getStatus(),
            e.getMessage(),
            e.getErrorCode(),
            ViewAssembler.toErrorDetailsVo(e.getDetails())));
  }

  @ExceptionHandler({MethodArgumentNotValidException.class, BindException.class})
  public ResponseEntity<ApiError> fields(BindException e) {
    var fields =
        e.getBindingResult().getFieldErrors().stream()
            .map(x -> new FieldErrorResult(x.getField(), x.getDefaultMessage()))
            .toList();
    return business(
        new ShopException(
            400,
            "MALL_VALIDATION_FAILED",
            "请求参数校验失败。",
            new ErrorDetailsResult(fields, null, null)));
  }

  @ExceptionHandler(AccessDeniedException.class)
  public ResponseEntity<ApiError> denied() {
    return business(new ShopException(403, "MALL_FORBIDDEN", "缺少接口权限。"));
  }

  @ExceptionHandler(DuplicateKeyException.class)
  public ResponseEntity<ApiError> duplicate() {
    return business(ShopException.conflict("MALL_DUPLICATE_VALUE", "唯一字段已存在。"));
  }

  @ExceptionHandler(MaxUploadSizeExceededException.class)
  public ResponseEntity<ApiError> large() {
    return business(new ShopException(413, "MALL_UPLOAD_TOO_LARGE", "上传文件过大。"));
  }

  @ExceptionHandler({
    org.springframework.http.converter.HttpMessageNotReadableException.class,
    org.springframework.web.method.annotation.MethodArgumentTypeMismatchException.class,
    jakarta.validation.ConstraintViolationException.class,
    org.springframework.web.bind.MissingServletRequestParameterException.class,
    org.springframework.web.multipart.support.MissingServletRequestPartException.class
  })
  public ResponseEntity<ApiError> invalid() {
    return business(ShopException.invalid("请求字段缺失、类型错误或含有未声明字段。"));
  }

  @ExceptionHandler(Exception.class)
  public ResponseEntity<ApiError> internal(Exception e) {
    org.slf4j.LoggerFactory.getLogger(getClass()).error("商城请求失败，异常类型={}", e.getClass().getName());
    if (e instanceof org.springframework.jdbc.BadSqlGrammarException sql)
      org.slf4j.LoggerFactory.getLogger(getClass())
          .error(
              "SQL结构错误，SQLState={}，vendorCode={}，SQL={}",
              sql.getSQLException().getSQLState(),
              sql.getSQLException().getErrorCode(),
              sql.getSql());
    return business(new ShopException(500, "MALL_INTERNAL_ERROR", "服务暂时不可用，请稍后重试。"));
  }
}
