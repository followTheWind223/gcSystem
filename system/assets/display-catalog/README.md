# 商城显示商品与本地图片

数据集 `display-catalog-v1` 是用户授权加入应用库的显示数据，不随结构迁移自动执行。

- 3 个虚构游戏：星海远征、永恒之境、机甲前线。
- 6 件已上架商品：星辉长剑·青曜、曜金猎弓、星蝶护符、寒霜结晶、远征补给宝箱、先驱战术头盔。
- 3 条轮播、7 张真实 PNG、每件商品 1 条初始库存流水；售价、划线价、库存、规格与交付字段见 [catalog.json](./catalog.json)。
- 不伪造销量、评价、会员、订单或支付。

## 存储与访问路由

本目录为可随仓库保存的原始素材。导入时调用 `POST /mall/media/images`，由后端检查并重新编码图片，再写入 `UPLOAD_PATH`（本机为 `system/data/uploads`）和 `mall_media`。

```text
原图：system/assets/display-catalog/<商品名>.png
实际文件：system/data/uploads/mall/YYYY/MM/DD/<32位随机名>.png
浏览器地址：/api/mall/media/<32位随机名>.png
```

数据库存媒体 ID、受控相对路径及校验值，不存 Windows 绝对路径、外部图片站点或 `localhost` 域名。沿用现有公开图片路由，匿名读取返回真实 `image/png`、`nosniff` 和不可变缓存头；只读取已登记媒体，不开放整个后端文件目录。

后台 5174 与用户端 5173 的 Vite、两端 Nginx 示例均保留 `/api/mall` 前缀。访问图片时不增加 `/admin-api`，也不把 `/images` 或 SPA 的 `index.html` 当作商城商品图片。物理文件移动时保持 `UPLOAD_PATH` 与 `relative_path` 对应，不改动两端共享的图片 URL 格式。

## 重新导入

先备份目标应用库并启动后端。安装 Python `requests`，在当前进程中配置一个具有商城媒体、分类、商品、轮播读写权限的后台令牌为 `GAMESHOP_ADMIN_TOKEN`，运行：

```powershell
python system/scripts/seed_display_catalog.py --base-url http://127.0.0.1:8080
```

令牌不写入源码、命令参数或断点文件。默认断点为 `system/data/display-catalog-state.json`，每次成功写入即保存；重复运行复用原图片和对象，不重置库存及用户修改。若发现非本数据集维护的同名内容，或已被人工移除的对象，会停止，不覆盖或自动恢复。不同数据库必须用 `--state` 指定独立断点文件。不要把断点文件当作数据库备份。

通过正式接口创建商品，自动建立图片关联与初始库存流水。实际应用库导入前已完整备份，并验证重复执行、文件 SHA-256/字节数、三个服务地址下的全部图片和非目录数据保持不变，见 [执行记录](../../../docs/validation/display-catalog.json)。

## 素材来源和提示

`starblade.png`、`sunbow.png`、`astral-charm.png`、`frost-crystal.png`、`supply-chest.png`、`vanguard-helmet.png` 均使用内置 `image_gen` 工具，以用户端原有原创 `item-atlas.png` 为参考，分别生成独立商品图，没有裁切图片或使用外部图片链接。六张图实际均为 1254×1254；`starblade-banner.png` 为项目已有的 1536×1024 原创横幅副本，其原提示见 [用户端素材记录](../../../systemUI/docs/assets.md)。

六张商品图使用相同完整提示模板，仅替换 `SUBJECT`：

> Use case: precise-object-edit. Asset type: individual square original game item product image for a Chinese game shop catalogue. Use the attached atlas as the source. Create ONE separate square 1024x1024 product artwork featuring only the SUBJECT from the atlas. Preserve that item's exact overall design, materials, colors and fine details. Fully isolate it from the other five tiles, center the whole item with generous 12% breathing room on all sides, on the same smooth very dark charcoal background. Luxury RPG inventory item cinematic 3D render, crisp metal and gem textures, soft colored rim light. All of the main item fits inside the image. No grid, no other items, no interface, no letters, no watermark, no labels. Original fictional game item, not an existing game brand.

| 文件 | SUBJECT |
| --- | --- |
| starblade.png | top-left silver sword with teal energy |
| sunbow.png | top-middle ornate gold and black recurve bow with amber energy string |
| astral-charm.png | top-right violet butterfly amulet with silver wings and purple gem |
| frost-crystal.png | bottom-left cyan ice crystal cluster with its silver rune ring |
| supply-chest.png | bottom-middle open ornate brass treasure chest glowing gold |
| vanguard-helmet.png | bottom-right red and black science fiction combat helmet |
