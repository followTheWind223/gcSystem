# gameshop 商城业务模块

独立 Maven 模块 `com.ruoyi:gameshop`，由 `ruoyi-admin` 装配。57 个商城业务操作使用 3.0.0 契约，已有若依接口保持原协议。模块依赖 `ruoyi-framework`，基础模块不反向依赖商城。

## 分层和对象边界

```text
controller                   HTTP 绑定、身份、权限、状态码和 Location
model/dto                    请求允许字段，Jakarta 校验；不绑定数据库实体
convert/CommandAssembler     DTO → Command 的显式转换
model/command + model/bo     Service 输入及内部业务对象
service + service/impl       业务规则、状态机、事务
model/query                  Service → Mapper 的查询条件，ID/金额/时间已转换
mapper + resources/mapper    参数绑定 SQL、行锁、条件更新
persistence/entity           独立持久化对象，只供 Mapper 与 Service 使用
model/result                 Service 输出，不作为 HTTP 或持久化对象
convert/ViewAssembler        Result → VO 的显式转换
model/vo + web               响应允许字段、分页外壳和错误协议
security/config/task         若依身份适配、商城授权链、配置和 Quartz 任务入口
```

Controller 不访问 Mapper；Service 不引用 DTO/VO/Servlet；Mapper 不接收网页表单。模型均是独立文件，不用一个实体贯穿接收、业务、存储和返回。请求未知字段、数字 ID、错误数量、缺失的必有可空字段都会拒绝；响应仍保留必有字段的 null。

## 已实现范围

- 账号认证直接复用若依原生接口。商城提供档案、改密、头像和交易归属；不再签发独立 JWT。普通用户无后台权限，管理员可使用商城，邮箱验证与找回关闭。
- 门户、分类、商品与评价公开查询；后台分类/商品/轮播增改查软删除、版本校验、图片上传和状态调整。
- 本人购物车与批量勾选；会员绑定的 5 分钟报价；创建订单的请求摘要与永久幂等键。
- 下单扣库存；首次支付增加销量；失败模拟不写成功事实；取消与超时回补一次；交付和完成状态同事务写入。
- 本人已完成明细的一次评价；公开脱敏；后台隐藏及原因；隐藏不释放额度。
- 后台会员启停、订单处理、脱敏查询、库存原子调整与流水；写操作使用若依权限及审计，审计不保存请求和响应中的私密资料。

交易在 Service 中声明事务，多商品固定分类/商品锁顺序，支付/取消持有订单锁并使用条件状态更新。SQL 全部参数绑定。MySQL 唯一键、外键和 CHECK 作为附加约束；Redis 不代替交易事实。富文本使用 jsoup 标签/属性允许列表，图片解码后统一重新编码为 PNG，支持 PNG/JPEG/WebP 输入；公开接口只返回受控图片。

## 接口、迁移与启动

- [详细用户端接口](../../docs/api/用户端接口详细说明.md)、[详细管理端接口](../../docs/api/管理端接口详细说明.md)、[REST 迁移对照](../../docs/api/REST迁移说明.md)、[OpenAPI](../../docs/api/openapi.yaml)。后台 REST 地址没有 `/list`。
- SQL 顺序为若依空库基线 → V001 表结构 → V002 Quartz 关单任务 → V003 后台菜单/路由/按钮权限 → V004 品牌 → V005 精简菜单 → V006 游戏区服 → V007 统一认证（演示 D001 必须先于 V007）。D001 是可选开发样本，不自动导入应用库，不重跑上游 DROP 脚本。
- `gameshopOrderExpiry.closeExpired()` 由若依 Quartz 每分钟执行，禁止并发；每笔关单调用同一个订单取消服务并独立事务，重启后补扫。
- 从 `system` 工作目录运行 `./mvnw.cmd -B package`，再运行 `./start.ps1`。配置见 `system/.env.example`，真实 `.env` 被 Git 忽略。认证仅使用若依 TOKEN_SECRET；旧商城认证配置已退役。
- 若依图形验证码保持开启；邮箱验证和邮箱找回不启用。详见[统一认证](../../docs/api/若依统一认证.md)。

## 后台页面与路由

V006 另增加 `/gameshop/game-servers` 游戏区服管理，共八页。区服按游戏新增、编辑、启停、软删除，结算使用选择ID并在订单保存名称快照，详见[区服文档](../../docs/api/游戏区服管理与结算.md)。

V003 注册 `/gameshop/categories`、`props`、`banners`、`members`、`orders`、`reviews`、`stock-logs` 七个动态路由，组件在 `adminsystemui/src/views/gameshop`。页面包含搜索、分页、顶部操作区、行操作、详情和状态反馈，按钮使用 `mall:*` 权限。权限由若依角色菜单分配；不会自动把商城权限授予普通角色。原管理员可看到新菜单，更新后需重新登录刷新菜单缓存。

分类、商品和轮播有独立字段表单；商品含受控图片上传、封面、规格、交付字段、详情和初始库存。商品已有库存通过“调整库存”操作增减并记录原因；后台订单可取消待支付或登记已支付订单的交付。评价隐藏、会员启停均要求原因。API 使用后端路径 `/mall/**`，浏览器经过 `/admin-api`；图片与用户接口 `/api/mall/**` 保留前缀代理。

## 可复现验证

```powershell
# 从 system 运行：编译、分层边界与事务声明检查
.\mvnw.cmd -B package

# 安装独立测试工具后，在 system 运行真实 MySQL/Redis/HTTP 验证
python -m pip install -r gameshop/tests/requirements.txt
python gameshop/tests/integration.py
# Windows 已安装 Edge 时，可加 --ui 验证后台真实浏览器操作
python gameshop/tests/integration.py --ui
```

集成脚本读取本地 `.env`，只创建随机 `gc_api_test_*` 库，并选择此前为空的 Redis DB 7–15；启动单独 18089 后端，结束后清理自己创建的资源，不清空应用 Redis。`--ui` 启动单独 15174 Vite，验证八页路由、操作区以及区服/分类/商品/库存/订单的真实页面操作。需要 MySQL 建库权限；原应用库不参与测试。测试日志、邮件、截图在仓库外 `.work/gameshop-integration`，不含输出到报告的令牌或密码。

本机验证结果以 [后端与后台验收记录](../../docs/后端与后台验收.md)为准；Mock 和契约校验不代替真实业务验证。SMTP 外部投递和其他部署平台需要在目标环境验证。
