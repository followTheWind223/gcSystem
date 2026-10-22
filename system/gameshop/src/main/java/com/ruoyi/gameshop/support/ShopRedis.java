package com.ruoyi.gameshop.support;

import com.ruoyi.gameshop.exception.ShopException;
import java.time.Duration;
import java.util.*;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Component;

/** Redis 原子操作：次数、有效期、验证及消费不可拆成竞态读写。 */
@Component
public class ShopRedis {
  private final StringRedisTemplate redis;

  public ShopRedis(StringRedisTemplate redis) {
    this.redis = redis;
  }

  public void put(String key, String value, int seconds) {
    redis.opsForValue().set(key, value, Duration.ofSeconds(seconds));
  }

  public String get(String key) {
    return redis.opsForValue().get(key);
  }

  public void delete(String key) {
    redis.delete(key);
  }

  public boolean once(String key, int seconds) {
    return Boolean.TRUE.equals(
        redis.opsForValue().setIfAbsent(key, "1", Duration.ofSeconds(seconds)));
  }

  public long increment(String key, int seconds) {
    return redis.execute(
        new DefaultRedisScript<Long>(
            "local n=redis.call('incr',KEYS[1]); if n==1 then redis.call('expire',KEYS[1],ARGV[1]);"
                + " end; return n",
            Long.class),
        List.of(key),
        String.valueOf(seconds));
  }

  public void rate(String key, int max, int seconds) {
    if (increment(key, seconds) > max)
      throw new ShopException(429, "MALL_RATE_LIMITED", "请求过于频繁，请稍后重试。");
  }

  public boolean consume(String key, String expected) {
    Long result =
        redis.execute(
            new DefaultRedisScript<Long>(
                "local v=redis.call('get',KEYS[1]); redis.call('del',KEYS[1]); if v and v==ARGV[1]"
                    + " then return 1 else return 0 end",
                Long.class),
            List.of(key),
            expected);
    return Long.valueOf(1).equals(result);
  }

  public boolean emailConsume(String key, String expected) {
    Long result =
        redis.execute(
            new DefaultRedisScript<Long>(
                "local v=redis.call('get',KEYS[1]); if not v then return 0 end; if v==ARGV[1] then"
                    + " redis.call('del',KEYS[1]); redis.call('del',KEYS[2]); return 1 end; local"
                    + " n=redis.call('incr',KEYS[2]); if n==1 then redis.call('expire',KEYS[2],300)"
                    + " end; if n>=5 then redis.call('del',KEYS[1]); end; return 0",
                Long.class),
            List.of(key, key + ":attempts"),
            expected);
    return Long.valueOf(1).equals(result);
  }
}
