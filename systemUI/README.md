# gameshop · 商城用户端

独立 Vue 3 游戏道具商城。技术栈：Vue 3、Vite、JavaScript、Vue Router 4、Pinia、Axios、Element Plus。界面采用炭黑与青绿色，使用本地原创游戏道具素材，适配桌面和手机。

开发与安装版本固定为 Node.js **24.20.0**、npm **11.19.0**。本目录为独立安装边界，使用自己的 `package-lock.json`；`.npmrc` 禁止依赖安装脚本。

## 运行

在本目录打开终端：

```powershell
npm ci
npm run dev
```

默认打开 <http://127.0.0.1:5173>，**直接连接真实后端**。后端需在 `127.0.0.1:8080` 运行；需要启动时，在 `../system` 执行 `.\start.ps1`。已有服务运行时直接复用，不必重复启动。

账号直接使用若依原生认证，与后台共用 sys_user。新注册账号默认 common 普通用户，只能使用商城；管理员也可登录商城。图形验证码填写图片内容，联系邮箱不做验证，不提供邮箱找回。详见[统一认证](../docs/api/若依统一认证.md)。

## 真实接口模式

```powershell
npm run dev:api
```

`dev:api` 与默认 `dev` 均连接真实后端；也可追加 `-- --port 5175` 单独预览。通过 Vite 同源代理访问 `http://127.0.0.1:8080/api/mall/**`，**完整保留 `/api/mall` 前缀**。代理目标可以在 `.env.local` 配置 `DEV_PROXY_TARGET`。没有后端响应时展示错误，不会自动回退演示数据。

当前契约 **3.0.0 / V007**。认证与业务的代理规则不同：

| 功能 | 浏览器请求 | 后端实际路径 |
| --- | --- | --- |
| 图形码 | `/api/auth/captchaImage` | `/captchaImage` |
| 注册、登录、退出 | `/api/auth/register`、`login`、`logout` | `/register`、`/login`、`/logout` |
| 当前账号和角色 | `/api/auth/getInfo` | `/getInfo` |
| 资料、头像、改密与商城交易 | `/api/mall/**` | 原样保留前缀 |

原生登录成功返回顶层 `token`；若依业务错误可能是 HTTP 200、body.code=500。商城业务仍使用 `data`、分页 `rows/total` 和原错误协议。旧商城 sessions、members 注册、邮箱验证码和邮箱找回接口已移除。

## 可选演示模式

```powershell
npm run dev:demo -- --port 5176
```

只有显式启动演示模式才启用内存 Mock。页脚“演示模式”可切换空态、断网、会话过期、缺货、下架、购物车失效、报价变化/过期、响应丢失及订单竞争等场景。

仅在此模式使用账号 `demo_member` / `Example123!`、图形码 `7`。账号、订单等保存在页面内存，刷新重置。新支付订单等待后台交付，用户端不提供自行完成订单入口。

## 已完成页面

- `/`：首页、推荐游戏、精选道具。
- `/props`：分类、关键词、价格区间、排序、分页，筛选同步 URL。
- `/props/:propId`：图片、价格库存、展示规格、详情、评价、加购、立即购买。
- `/login`、`/register`、`/forgot-password`：仅保留全屏主体，无页头、页脚；图形验证码填满图片区域并支持点击刷新，登录注册调用若依图形码；找回路由只提示联系管理员，保留安全登录跳回。
- `/cart`：数量、勾选、删除、失效行、服务端金额、批量结算。
- `/checkout`：服务端报价、交付信息、报价有效期、确认、幂等重试。
- `/orders/:orderNo/pay`：显示支付结果，入口统一为“去支付”。
- `/orders/:orderNo`：订单状态、交付记录、取消、时间线、逐明细评价。
- `/me/orders`、`/me/reviews`、`/me/profile`、`/me/password`：玩家中心。
- 未知路由：404。公开页面可匿名浏览，会员页面自动跳转登录。

## 关键约束

会员令牌只存在 Pinia 内存，不写 localStorage、sessionStorage、Cookie 或 URL，两端共用账号但不共享前端存储键。退出、改密、401 时清除会员缓存；旧会话的延迟响应不会回填新会话数据。刷新受保护页需要重新登录。

ID 始终保留字符串；金额格式化及 Mock 辅助计算使用整数分（BigInt）。真实下单金额只使用服务端报价。交付仅收集当前商品要求的游戏账号/区服/角色名，不收集游戏密码。

创建订单只提交 `quoteToken/requestKey/deliveryInfo/remark`。请求结果不确定时保留整个 payload 和 UUID，重试原请求；报价冲突要求重新预览和确认。刷新丢失确认单时引导先核对我的订单。购物车增量加购超时先读回核对，不自动重发。

支付/取消后以返回或重新查询的状态为准。倒计时以 `serverTime` 校时，归零禁用支付并查询，不在本地伪造取消状态；订单每 15 秒以及页面恢复可见时刷新。评价超时先核对已提交结果，不盲目再次发表。

富文本经 `DOMParser` 解析为严格允许列表的 Vue VNode，过滤脚本、事件、SVG、外链及非商城图片，不使用不受控的 `v-html`。评价始终按纯文本展示。头像使用 multipart `file`，客户端检查格式、2MiB 大小和 4096 像素，后端仍须执行权威验证及重编码。

## 构建与检查

```powershell
npm test             # 金额精度、重定向、凭证格式、媒体地址
npm run test:e2e     # Chrome 浏览器：Mock 流程、响应式、真实 Axios 传输契约
npm run test:live    # Chrome + 隔离 Spring Boot / MySQL / Redis 真实联调
npm run build        # 生产版，真实 API，剔除 Mock 模块和测试账号
npm run build:demo   # 仅供演示，显式包含 Mock
npm run preview     # 预览最近一次 dist 构建，默认 4173
npm audit
npm audit signatures
```

Playwright 使用本机 Chrome，契约测试自动启动 5176 演示服务器及 5175 真实接口模式服务器，与日常开发的 5173 分离；若使用自建服务器，须确保模式一致。未安装 Chrome 的环境可安装 Chrome 或调整测试中的 `channel` 并准备对应浏览器。测试输出及截图位于忽略目录 `test-results/`。

真实联调依赖已构建的后端 jar、`system/.env`、MySQL/Redis、Python `pymysql requests Pillow`。`npm run test:live` 或 `python tests/live/run.py --ruoyi-auth` 在随机 gc_ui_test_* 数据库、空闲 Redis DB 7–15、18090 后端和 15173 用户端验证若依认证及角色边界；结束后只清理自己的测试资源。另需管理端 5174 开发服务，浏览器为该次测试将其代理请求转到隔离后端。结果位于 `.live-test-results/`，不写应用库。

覆盖验证码消费、原生注册/登录/退出、默认角色、后台越权拒绝、并发建档、历史账号迁移、订单/购物车归属、改密与禁用撤销会话，以及两端浏览器登录。旧 `--email-policy` 测试已退役，不代表当前认证流程。

生产部署将 `dist/` 交由 Web 服务器托管。`vite preview` 只用于静态预览，不包含生产 API 反向代理。Nginx 同源代理、SPA 深链接回退和安全头参考 [部署示例](deploy/nginx.conf.example)。

## 验证边界

构建、实际执行的自动化结果与剩余限制见 [验证记录](docs/verification.md)。`test:e2e` 使用 Mock 或浏览器契约拦截；`test:live` 使用真实后端、MySQL、Redis ，两类结果分别记录。

图片来源、生成提示与本地路径见 [素材说明](docs/assets.md)。本次统一认证和普通角色限制已同步后端、管理端、迁移和接口契约。
