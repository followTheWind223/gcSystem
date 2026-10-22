# gcSystem · 游戏道具商城

用户端和管理端共用若依原生登录/注册。新账号默认普通用户 common，仅可使用商城；后台页面与接口均限制访问。原商城账号已经迁移到 sys_user，保留密码和交易归属。详见 [统一认证与权限](./docs/api/若依统一认证.md)。

虚拟游戏道具商城课程项目，采用前后端分离。若依 Spring Boot 3 后端已实现独立 gameshop 模块及 57 个商城业务接口，认证复用若依原生接口；管理端八个页面已接入真实接口，商城用户端位于 systemUI。

## 项目结构

```text
gcSystem/
├── system/              # RuoYi-Vue springboot3，Maven 多模块后端
├── adminsystemui/       # RuoYi-Vue3 管理端，Vue 3 + Vite
├── systemUI/            # Vue 3 商城用户端
├── sql/                 # 完整数据库快照、上传图片包及迁移说明
├── deploy/nginx/        # 管理端部署代理示例
├── docs/                # 需求、架构、上游与环境验证记录
└── AGENTS.md            # 开发约束和项目进度
```

按本次用户指令，后端目录由 `gsSystem` 调整为 `system`，管理端由 `gsSystemAdminUI` 调整为 `adminsystemui`。源码导入时排除了上游 `.git`，许可证分别保留在两工程的 `LICENSE`。

用户端工程目录当前为 `systemUI`，替代原 `gsSystemUI`；用户端交接与工程初始化都使用当前目录。

## 环境与启动

后端以 JDK 17 编译，Maven Wrapper 固定 3.9.10；管理端固定 Node.js 24.20.0、npm 11.19.0。当前本机数据库为 MySQL 8.3.0，Redis 为 5.0.14.1；MySQL 8.0 部署环境仍需单独验证。

后端配置：`system/.env`（本地私密文件，Git 忽略），模板为 `system/.env.example`。本机文件已生成独立随机 JWT 密钥，数据库密码由使用者在本地填写。Spring 自动从 `system` 工作目录读取该文件；IDE 的 Working directory 也必须设为 `system`。详见 [环境配置与验证](./docs/环境配置与验证.md)。

首次在新环境使用时复制模板，填写数据库连接、密码和随机 `TOKEN_SECRET`。迁移现有数据使用下方的完整备份；从零初始化则按 [增量 SQL 说明](./system/sql/README.md) 执行。两种方式不要混用，不要在已有业务库直接执行上游建表脚本。

在 PowerShell 中启动后端：

```powershell
cd system
# JAVA_HOME 指向 JDK 17 或更高版本，避免 PATH 中旧 Java 抢先。
.\mvnw.cmd -B clean package
.\start.ps1
# 后续源码变更后可用 .\start.ps1 -Build 重新构建并启动。
```

在另一终端启动管理端：

```powershell
cd adminsystemui
npm ci
npm run dev
```

访问 [管理后台](http://127.0.0.1:5174)，后端监听 `127.0.0.1:8080`。初始后台账号沿用若依种子数据 `admin / admin123`，仅用于本机首次登录，部署前修改。

开发、测试构建、生产构建均使用 `/admin-api`；Vite 和 Nginx 均将此前缀去掉后转发到后端。端口和代理目标可在 `adminsystemui/.env.local` 覆盖，前端环境文件禁止存放私密凭证。

```powershell
# 管理端生产构建
npm run build:prod
# 管理端预发布构建
npm run build:stage
```

管理端默认禁用依赖安装脚本，npm 缓存位于根目录 `.cache/npm`，锁文件 `package-lock.json` 纳入版本控制。没有额外的 `test` 或 `lint` 脚本。

## 数据库与现有数据迁移

完整备份已放在项目根目录的 [sql/](./sql/README.md)，快照时间为 **2026-10-23 01:39:35（Asia/Shanghai）**。

- [gc_system_full.sql](./sql/gc_system_full.sql)：47 张表、470 条记录，包含完整表结构、现有账号权限、商品、订单、购物车、配置、日志和 V001–V007 版本记录。
- [uploads.zip](./sql/uploads.zip)：7 个上传图片文件，恢复数据库时需要一起迁移。
- [校验结果.json](./sql/校验结果.json)：逐表行数与 SHA-256；已在临时空库验证全部数据及表结构恢复一致。

先停止目标环境后端，使用 MySQL 客户端连接目标实例（密码交互输入）：

```powershell
mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p
```

然后在 MySQL 客户端执行，路径按目标机器实际位置调整：

```sql
SOURCE D:/游戏商城系统/gcSystem/sql/gc_system_full.sql;
```

**SQL 自带建库和 `USE gc_system`，并会替换同名表，请在空环境或确认可覆盖的目标库导入。** 将 `uploads.zip` 解压到 `system/data/`，保留 `system/data/uploads/` 层级；配置目标 `system/.env` 的数据库、Redis 和上传目录后启动项目。完整备份已经包含 V001–V007，无需再次执行上游 SQL、增量迁移或演示脚本。账号密码保持原样，迁移后重新登录。

详细环境要求、Linux 路径示例和校验方法见 [sql/README.md](./sql/README.md)。

## 当前开发范围

已实现若依统一认证、商品、门户、图片、购物车、报价、订单、模拟支付、取消/超时关单、交付、评价及后台管理。业务位于 [gameshop 模块](./system/gameshop/README.md)，按 Controller/Service/Mapper 分层，DTO/BO/Query/Entity/Result/VO 分离。管理端“游戏商城”下有分类、商品、轮播、会员、订单、评价、库存流水及游戏区服八页，包含实际操作区与权限按钮。

应用库已备份并应用 V001–V007，当前共 47 表；没有导入演示订单或会员。后台首页已替换为真实数据的商城工作台，登录页、标识、默认公告和菜单均已商城化。已按用户要求移除部门/岗位、系统监控、系统工具及其后代菜单和路由。登录后台后刷新菜单即可进入 `/gameshop/props` 等页面，创建商品前先创建分类并上传图片。当前契约为 3.0.0，对接前查看[路径迁移对照](./docs/api/REST迁移说明.md)。验证范围见[后端与后台验收](./docs/后端与后台验收.md)。

已按用户授权加入 3 个游戏分类、6 件商品和 3 条轮播，7 张图片实际存储在后端 `system/data/uploads/mall`，统一通过 `/api/mall/media/{fileName}` 读取。后台有缩略图与预览；刷新 [商城](http://127.0.0.1:5173) 或 [商品管理](http://127.0.0.1:5174/gameshop/props) 即可查看。[素材、生成提示与可重复导入说明](./system/assets/display-catalog/README.md)随工程保存。

## 文档

- [数据库设计与字段字典](./docs/database/README.md)：V001 结构、14 张业务表、1 张版本表、169 字段；V002 关单任务、V003 后台路由及权限、V004 默认展示、V005 菜单精简已应用到开发库。
- [商城接口设计](./docs/api/README.md)：契约 3.0.0；[用户端详细接口](./docs/api/用户端接口详细说明.md)和[管理端详细接口](./docs/api/管理端接口详细说明.md)逐项列出请求/返回字段及完整成功、失败 JSON，含 OpenAPI 和 Mock 示例。
- [用户端开发交接](./docs/用户端开发交接.md)：供独立用户端开发使用的页面映射、请求封装、Mock 与协作边界。
- [环境配置与验证](./docs/环境配置与验证.md)：端口、私密配置、数据库初始化、实际验证与遗留项。
- [上游源码记录](./docs/上游源码记录.md)：仓库、分支、完整提交 SHA、许可证和本地修改。
- [开发流程与架构设计](./docs/开发流程与架构设计.md)：业务范围、数据模型、状态机、接口和阶段门槛。
- [AGENTS.md](./AGENTS.md)：长期约束与真实进度。
- [原始需求](./docs/开题(2).doc)：原文件保留。

项目仓库：[followTheWind223/gcSystem](https://github.com/followTheWind223/gcSystem)。本项目自身的开源许可证尚未选定，上游 MIT 版权与许可保持原样。
