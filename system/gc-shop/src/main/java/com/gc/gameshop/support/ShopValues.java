package com.gc.gameshop.support;

import com.gc.gameshop.exception.ShopException;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.security.*;
import java.time.*;
import java.util.*;

public final class ShopValues {
  public static final ZoneId ZONE = ZoneId.of("Asia/Shanghai");

  private ShopValues() {}

  public static long id(String s) {
    try {
      if (s == null || !s.matches("[1-9][0-9]{0,18}")) throw new IllegalArgumentException();
      return Long.parseLong(s);
    } catch (RuntimeException e) {
      throw ShopException.invalid("ID 必须为正整数十进制字符串。");
    }
  }

  public static String id(Long v) {
    return v == null ? null : v.toString();
  }

  public static String money(BigDecimal v) {
    return v == null ? null : v.setScale(2).toPlainString();
  }

  public static BigDecimal amount(String s) {
    try {
      if (s == null || !s.matches("(0|[1-9][0-9]{0,9})\\.[0-9]{2}"))
        throw new IllegalArgumentException();
      return new BigDecimal(s);
    } catch (RuntimeException e) {
      throw ShopException.invalid("金额必须为两位小数字符串。");
    }
  }

  public static void capacity(BigDecimal v) {
    if (v.signum() <= 0 || v.compareTo(new BigDecimal("9999999999.99")) > 0)
      throw ShopException.invalid("金额超出范围。");
  }

  public static String time(LocalDateTime v) {
    return v == null
        ? null
        : java.time.format.DateTimeFormatter.ISO_OFFSET_DATE_TIME.format(
            v.atZone(ZONE).toOffsetDateTime());
  }

  public static LocalDateTime now() {
    return LocalDateTime.now(ZONE);
  }

  public static String clean(String v) {
    return v == null || v.trim().isEmpty() ? null : v.trim();
  }

  public static String hash(String s) {
    try {
      return HexFormat.of()
          .formatHex(
              MessageDigest.getInstance("SHA-256").digest(s.getBytes(StandardCharsets.UTF_8)));
    } catch (NoSuchAlgorithmException e) {
      throw new IllegalStateException(e);
    }
  }

  public static String random() {
    byte[] b = new byte[32];
    new SecureRandom().nextBytes(b);
    return HexFormat.of().formatHex(b);
  }

  public static String number(String prefix) {
    return prefix
        + java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS").format(now())
        + UUID.randomUUID().toString().replace("-", "").substring(0, 12).toUpperCase(Locale.ROOT);
  }

  public static void unique(List<?> values) {
    if (values == null || values.size() != new HashSet<>(values).size())
      throw ShopException.invalid("数组元素不能重复。");
  }
}
