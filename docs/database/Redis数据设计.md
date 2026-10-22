# 商城 Redis 临时数据设计

> V007 / 契约 3.0.0：认证改用若依 `login_tokens:{uuid}`、`captcha_codes:{uuid}` 和密码错误计数。会话按若依续期，凭证指纹用于撤销密码变化后的旧会话。下表 mall:member:session、mall:captcha、mall:email-code、mall:login-fail 及邮箱限流是已退役的历史设计，不再由认证入口创建；报价及商城业务限流仍使用。

对应数据库 V001、接口 2.0.0。永久会员、订单、支付、库存、交付和评价事实以 MySQL 为准；Redis 不代替库存事务或永久幂等唯一键。当前实现使用下列键；sessions 失效索引为预留设计，当前直接依靠数据库 session_version 撤销旧会话。

| 键模式 | 值及必要字段 | TTL | 消费和失效规则 |
| --- | --- | --- | --- |
| mall:member:session:{jti} | 字符串 memberId:sessionVersion；issuedAt/expiresAt 在签名令牌中 | 1800 秒，绝对期限，不滑动续期 | 退出删当前会话；禁用/改密/重置使旧版本失效；受保护请求仍核验数据库状态和版本 |
| mall:member:sessions:{memberId} | 预留，当前未创建；不作为会话有效性依据 | 至少覆盖有效会话期限，定期清过期成员 | 只是失效索引，不能跳过 MySQL session_version 校验 |
| mall:captcha:{captchaId} | 服务端计算的答案摘要、创建时间、有效期 | 120 秒 | 图形码一次性；核验失败或已消费均要求重新获取；开发示例固定图片不能成为真实后门 |
| mall:email-code:{scene}:{emailHash} | HMAC 摘要、attempts、expiresAt | 300 秒 | HMAC 绑定邮箱和 REGISTER/RESET_PASSWORD 场景；原子比较、计次、消费；最多 5 次错误尝试 |
| mall:quote:{memberId}:{tokenHash} | QuoteSnapshot：来源、商品/数量/价格/展示快照、交付字段并集、cartVersions；到期由键 TTL 控制 | 300 秒 | 绑定当前会员；不扣库存；创建时重新检查价格、状态、数量和库存 |
| mall:rate:email:{scene}:{emailHash}:cooldown | 最近一次发码额度 | 60 秒 | 相同邮箱场景重发间隔 |
| mall:rate:email:{emailHash}:hour | 发码次数 | 固定一小时窗口 | 每邮箱最多 5 次，不能通过切换场景绕过小时额度 |
| mall:rate:email-ip:{ipHash}:hour | 发码次数 | 固定一小时窗口 | 每 IP 最多 20 次 |
| mall:login-fail:{usernameHash}:{ipHash} | 失败次数、锁定到期时间 | 600 秒 | 达到 5 次后限制 10 分钟，成功登录清相应失败状态 |
| mall:rate:public:{ipHash} | 公开读/图形验证码额度 | 60 秒窗口 | 120 次/分钟，超限返回 Retry-After |
| mall:rate:member:{memberId} | 普通受保护请求额度 | 60 秒窗口 | 120 次/分钟 |
| mall:rate:order:{memberId} | 下单额度 | 60 秒窗口 | 20 次/分钟；网络重放应先能读取已有原单，不重复创建事实 |

emailHash/usernameHash/ipHash 为规范化值的摘要，键中不放原始联系方式。邮箱码使用服务端保密配置的 HMAC，而不是无盐六位数字 SHA-256；响应和普通日志都不回显真实码。验证码核验、计数、消费使用原子操作，当前已使用原子 Lua 实现。

报价内部值示例（不是前端请求体）：

```json
{
  "memberId": 2001,
  "source": "CART",
  "items": [
    {
      "propId": "1001",
      "cartItemId": "4001",
      "propName": "星辉长剑",
      "coverUrl": "/api/mall/media/0123456789abcdef0123456789abcdef.png",
      "specs": [
        {
          "name": "品质",
          "value": "史诗"
        }
      ],
      "unitPrice": "49.90",
      "quantity": 2,
      "subtotal": "99.80",
      "stock": 8
    }
  ],
  "deliveryFields": [
    "gameAccount",
    "serverName",
    "roleName"
  ],
  "cartVersions": [
    "2026-10-22T20:00:00+08:00"
  ]
}
```

前端只拿不透明 quoteToken，不能改写以上价格或伪造 memberId。订单请求摘要在 MySQL 永久记录，精确重放先查 mall_order(member_id,request_key)，即使报价键已经过期仍能返回原订单；新键则必须拥有有效报价。Redis 故障不能把幂等检查降级为“无重复”。

当前开发 Redis 为 DB 6，后台已有若依键前缀不改；商城使用 mall:* 空间。会员签名、验证码 HMAC 和测试邮件适配器已独立注入，不复用后台密钥，也不写进前端环境文件。
