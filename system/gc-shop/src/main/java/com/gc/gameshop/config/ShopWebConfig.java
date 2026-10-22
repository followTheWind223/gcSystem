package com.gc.gameshop.config;

import com.fasterxml.jackson.databind.*;
import java.lang.reflect.Type;
import java.util.List;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.*;
import org.springframework.http.converter.*;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class ShopWebConfig implements WebMvcConfigurer {
  private final ObjectMapper mapper;

  public ShopWebConfig(ObjectMapper mapper) {
    this.mapper = mapper;
  }

  @Override
  public void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
    ObjectMapper strict =
        mapper
            .copy()
            .enable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES)
            .disable(DeserializationFeature.ACCEPT_FLOAT_AS_INT)
            .disable(MapperFeature.ALLOW_COERCION_OF_SCALARS);
    strict
        .coercionConfigFor(com.fasterxml.jackson.databind.type.LogicalType.Textual)
        .setCoercion(
            com.fasterxml.jackson.databind.cfg.CoercionInputShape.Integer,
            com.fasterxml.jackson.databind.cfg.CoercionAction.Fail)
        .setCoercion(
            com.fasterxml.jackson.databind.cfg.CoercionInputShape.Float,
            com.fasterxml.jackson.databind.cfg.CoercionAction.Fail)
        .setCoercion(
            com.fasterxml.jackson.databind.cfg.CoercionInputShape.Boolean,
            com.fasterxml.jackson.databind.cfg.CoercionAction.Fail);
    converters.add(
        0,
        new MappingJackson2HttpMessageConverter(strict) {
          @Override
          public boolean canRead(Class<?> c, MediaType t) {
            return c.getName().startsWith("com.gc.gameshop.model.dto.") && super.canRead(c, t);
          }

          @Override
          public boolean canRead(Type t, Class<?> context, MediaType media) {
            return t instanceof Class<?> c
                && c.getName().startsWith("com.gc.gameshop.model.dto.")
                && super.canRead(t, context, media);
          }

          @Override
          public boolean canWrite(Class<?> c, MediaType t) {
            return false;
          }

          @Override
          public boolean canWrite(Type t, Class<?> c, MediaType m) {
            return false;
          }
        });
  }
}
