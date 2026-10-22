package com.gc.framework.config;

import java.nio.charset.Charset;
import org.springframework.data.redis.serializer.RedisSerializer;
import org.springframework.data.redis.serializer.SerializationException;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONReader;
import com.alibaba.fastjson2.JSONWriter;
import com.alibaba.fastjson2.filter.Filter;
import com.gc.common.constant.Constants;

/**
 * Redis使用FastJson序列化
 * 
 * @author ruoyi
 */
public class FastJson2JsonRedisSerializer<T> implements RedisSerializer<T>
{
    public static final Charset DEFAULT_CHARSET = Charset.forName("UTF-8");

    private static final JSONReader.AutoTypeBeforeHandler CURRENT_TYPES =
            JSONReader.autoTypeFilter(Constants.JSON_WHITELIST_STR);

    // 兼容改包前的 Redis 类型标记；仅转换类型名，不修改昵称、备注等业务值。
    // 转换后仍经过当前包白名单，写入缓存时一律使用 com.gc。
    static final Filter AUTO_TYPE_FILTER = (JSONReader.AutoTypeBeforeHandler) (typeName, expectClass, features) -> {
        String currentName = typeName.startsWith("com.ruoyi.")
                ? "com.gc." + typeName.substring("com.ruoyi.".length()) : typeName;
        return CURRENT_TYPES.apply(currentName, expectClass, features);
    };

    private Class<T> clazz;

    public FastJson2JsonRedisSerializer(Class<T> clazz)
    {
        super();
        this.clazz = clazz;
    }

    @Override
    public byte[] serialize(T t) throws SerializationException
    {
        if (t == null)
        {
            return new byte[0];
        }
        return JSON.toJSONString(t, JSONWriter.Feature.WriteClassName).getBytes(DEFAULT_CHARSET);
    }

    @Override
    public T deserialize(byte[] bytes) throws SerializationException
    {
        if (bytes == null || bytes.length <= 0)
        {
            return null;
        }
        String str = new String(bytes, DEFAULT_CHARSET);

        return JSON.parseObject(str, clazz, AUTO_TYPE_FILTER);
    }
}
