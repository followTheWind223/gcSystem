# 游戏道具商城管理后台

Vue 3 + Vite + Element Plus 管理端，使用独立后台账号及菜单、角色、按钮权限。

## 本机启动

在当前目录执行：

```powershell
npm ci
npm run dev
```

固定 Node.js 24.20.0 / npm 11.19.0；开发地址 `http://127.0.0.1:5174`。先按根目录说明配置并启动 `system` 后端。

```powershell
npm run build:prod
npm run build:stage
```

## 页面与数据

- `/index`：商城工作台，展示真实在售商品、待交付订单、待支付订单和会员数量；按当前账号权限加载。
- `/gameshop/categories`、`/gameshop/props`、`/gameshop/banners`：分类、道具与轮播维护。
- `/gameshop/orders`、`/gameshop/members`、`/gameshop/reviews`、`/gameshop/stock-logs`：订单交付、会员、评价和库存流水。
- 工作台卡片携带状态筛选，订单“去处理”携带订单号；进入管理列表后使用行操作处理。
- 系统管理保留账号、角色、菜单、字典、参数、公告和日志；按用户要求移除部门/岗位、系统监控和系统工具的菜单及路由，自动关单仍在后台执行。

开发代理 `/admin-api` 转发到后端时去掉前缀，`/api/mall` 保留原路径。前端环境文件只保存公开配置；生产反向代理见 [Nginx 示例](../deploy/nginx/admin.conf.example)。

## 展示配置

- 标题：`.env.development`、`.env.production`、`.env.staging` 的 `VITE_APP_TITLE`。
- 商城标识与浏览器图标：`public/brand.svg`；默认头像：`src/assets/images/shop-avatar.svg`。
- 登录与注册共用 `ShopAuthBrand` 和 `shop-auth.scss`；默认不填入账号密码。
- 页脚：`src/settings.js`；首页：`src/views/index.vue`。
- 分类、商品、轮播列表均有本地图片缩略图，点击可预览；图片直接使用 `/api/mall/media/`，由公开商城代理转发，不增加 `/admin-api` 前缀。显示数据的原图和导入脚本见[素材说明](../system/assets/display-catalog/README.md)。
- 新环境顺序执行后端 V001～V005；V004 精确替换上游默认展示，V005 精简指定菜单及角色关联；不导入商城业务样本。

本工程基于 RuoYi-Vue3 修改。原始许可证和源码版权声明保留在 [LICENSE](./LICENSE)，固定来源及版本见[上游源码记录](../docs/上游源码记录.md)。接口字段、权限及 JSON 返回数据见[接口契约](../docs/api/README.md)。
