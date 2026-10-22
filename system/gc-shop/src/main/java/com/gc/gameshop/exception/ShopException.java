package com.gc.gameshop.exception;

import com.gc.gameshop.model.result.ErrorDetailsResult;

public class ShopException extends RuntimeException {
  private final int status;
  private final String errorCode;
  private final ErrorDetailsResult details;

  public ShopException(int status, String errorCode, String message) {
    this(status, errorCode, message, null);
  }

  public ShopException(int status, String errorCode, String message, ErrorDetailsResult details) {
    super(message);
    this.status = status;
    this.errorCode = errorCode;
    this.details = details;
  }

  public int getStatus() {
    return status;
  }

  public String getErrorCode() {
    return errorCode;
  }

  public ErrorDetailsResult getDetails() {
    return details;
  }

  public static ShopException invalid(String message) {
    return new ShopException(400, "MALL_VALIDATION_FAILED", message);
  }

  public static ShopException missing() {
    return new ShopException(404, "MALL_RESOURCE_NOT_FOUND", "资源不存在。");
  }

  public static ShopException conflict(String code, String message) {
    return new ShopException(409, code, message);
  }
}
