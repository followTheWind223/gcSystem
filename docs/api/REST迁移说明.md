# REST 接口 2.0.0 路径迁移

本版按用户要求在独立 gc-shop 模块实现；保持 operationId 和业务 DTO，修改以下路径/方法。用户端与后台必须同步，不提供会混淆语义的旧动作别名。

| operationId | 1.1.0 | 2.0.0 |
| --- | --- | --- |
| `memberGetCaptcha` | `GET /api/mall/auth/captcha` | `GET /api/mall/captcha` |
| `memberSendEmailCode` | `POST /api/mall/auth/email-codes` | `POST /api/mall/email-codes` |
| `memberRegister` | `POST /api/mall/auth/register` | `POST /api/mall/members` |
| `memberLogin` | `POST /api/mall/auth/login` | `POST /api/mall/sessions` |
| `memberLogout` | `POST /api/mall/auth/logout` | `DELETE /api/mall/sessions/current` |
| `memberResetPassword` | `POST /api/mall/auth/password/reset` | `POST /api/mall/password-resets` |
| `memberPreviewOrder` | `POST /api/mall/orders/preview` | `POST /api/mall/order-quotes` |
| `memberCancelOrder` | `POST /api/mall/orders/{orderNo}/cancel` | `PUT /api/mall/orders/{orderNo}/cancellation` |
| `memberMockPay` | `POST /api/mall/orders/{orderNo}/mock-pay` | `POST /api/mall/orders/{orderNo}/payments` |
| `adminListCategories` | `GET /mall/categories/list` | `GET /mall/categories` |
| `adminListBanners` | `GET /mall/banners/list` | `GET /mall/banners` |
| `adminListProps` | `GET /mall/props/list` | `GET /mall/props` |
| `adminListMembers` | `GET /mall/members/list` | `GET /mall/members` |
| `adminListOrders` | `GET /mall/orders/list` | `GET /mall/orders` |
| `adminCancelOrder` | `POST /mall/orders/{orderId}/cancel` | `PUT /mall/orders/{orderId}/cancellation` |
| `adminCompleteOrder` | `POST /mall/orders/{orderId}/complete` | `PUT /mall/orders/{orderId}/delivery` |
| `adminListReviews` | `GET /mall/reviews/list` | `GET /mall/reviews` |
| `adminHideReview` | `POST /mall/reviews/{reviewId}/hide` | `PUT /mall/reviews/{reviewId}/visibility` |
| `adminListStockLogs` | `GET /mall/stock-logs/list` | `GET /mall/stock-logs` |

后台图片创建返回 201 和 Location；新增 405/406/415 的协议错误码，错误 HTTP 与 body.code 一致。其余 JSON 外壳、字段、金额字符串、ID 字符串与幂等语义保持。

结构字段仍对应 V001；V002 只注册 Quartz 关单任务，不改字段。实现与验证见 [gc-shop 模块](../../system/gc-shop/README.md)。
