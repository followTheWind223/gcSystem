package com.ruoyi.gameshop.support;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;

@Component
public class ShopJson {
  private final ObjectMapper mapper;

  public ShopJson(ObjectMapper mapper) {
    this.mapper = mapper;
  }

  public String write(Object value) {
    try {
      return mapper.writeValueAsString(value);
    } catch (Exception e) {
      throw new IllegalStateException("JSON 序列化失败", e);
    }
  }

  public <T> T read(String value, Class<T> type) {
    try {
      return mapper.readValue(value, type);
    } catch (Exception e) {
      throw new IllegalStateException("持久化 JSON 不合法", e);
    }
  }

  public <T> T read(String value, TypeReference<T> type) {
    try {
      return mapper.readValue(value, type);
    } catch (Exception e) {
      throw new IllegalStateException("持久化 JSON 不合法", e);
    }
  }
}
