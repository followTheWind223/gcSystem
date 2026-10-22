package com.gc.gameshop;

import static org.junit.jupiter.api.Assertions.*;

import com.gc.common.core.domain.entity.SysDictData;
import com.gc.common.core.domain.entity.SysRole;
import com.gc.common.core.domain.model.LoginUser;
import com.gc.framework.config.FastJson2JsonRedisSerializer;
import java.nio.charset.StandardCharsets;
import java.util.List;
import org.junit.jupiter.api.Test;

class RedisNamespaceCompatibilityTest {
  private final FastJson2JsonRedisSerializer<Object> serializer =
      new FastJson2JsonRedisSerializer<>(Object.class);

  @Test
  void restoresLegacySessionWithNestedIdentityAndCredentialStamp() {
    String cached = """
        {"@type":"com.ruoyi.common.core.domain.model.LoginUser","userId":42,
         "token":"test-session","credentialStamp":"test-fingerprint","expireTime":1893456000000,
         "permissions":["mall:prop:list"],
         "user":{"@type":"com.ruoyi.common.core.domain.entity.SysUser","userId":42,
           "userName":"player","nickName":"com.ruoyi. is a literal nickname",
           "roles":[{"@type":"com.ruoyi.common.core.domain.entity.SysRole","roleId":2,"roleKey":"common"}]}}
        """;
    LoginUser login = assertInstanceOf(LoginUser.class, serializer.deserialize(cached.getBytes(StandardCharsets.UTF_8)));
    assertEquals(42L, login.getUserId());
    assertEquals("test-session", login.getToken());
    assertEquals("test-fingerprint", login.getCredentialStamp());
    assertEquals(1893456000000L, login.getExpireTime());
    assertEquals("com.ruoyi. is a literal nickname", login.getUser().getNickName());
    assertEquals("common", assertInstanceOf(SysRole.class, login.getUser().getRoles().get(0)).getRoleKey());
    assertTrue(login.getPermissions().contains("mall:prop:list"));
    String rewritten = new String(serializer.serialize(login), StandardCharsets.UTF_8);
    assertTrue(rewritten.contains("\"@type\":\"com.gc.common.core.domain.model.LoginUser\""));
    assertFalse(rewritten.contains("\"@type\":\"com.ruoyi."));
    assertInstanceOf(LoginUser.class, serializer.deserialize(serializer.serialize(login)));
  }

  @Test
  void restoresLegacyDictionaryList() {
    String cached = """
        [{"@type":"com.ruoyi.common.core.domain.entity.SysDictData","dictCode":1,
          "dictType":"sys_normal_disable","dictLabel":"正常","dictValue":"0","status":"0"}]
        """;
    List<?> values = assertInstanceOf(List.class, serializer.deserialize(cached.getBytes(StandardCharsets.UTF_8)));
    SysDictData entry = assertInstanceOf(SysDictData.class, values.get(0));
    assertEquals("正常", entry.getDictLabel());
    assertEquals("0", entry.getDictValue());
  }

  @Test
  void retainsStringsAndNullWithoutTypeConversion() {
    assertNull(serializer.deserialize(new byte[0]));
    assertEquals("com.ruoyi.common.Sample", serializer.deserialize(serializer.serialize("com.ruoyi.common.Sample")));
  }
}
