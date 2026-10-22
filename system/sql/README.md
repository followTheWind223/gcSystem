# 数据库脚本

迁移现有全部数据请使用项目根目录的 [sql/gc_system_full.sql](../../sql/gc_system_full.sql) 和 [完整恢复说明](../../sql/README.md)。本目录保存从零初始化和升级所需的增量脚本，不要在导入完整快照后重复执行。

已有应用库升级 V007：先停止后端，在 `system` 运行 `python scripts/migrate_ruoyi_identity.py`；依赖 pymysql 和 PATH 中的 mysqldump。脚本完整备份后迁移，检查历史账号密码及业务记录，已有 V007 时跳过。若有商城/系统同名账号会在变更前拒绝，必须核实身份后处理，不能自动合并。

商城当前结构版本 V007，对应接口 3.0.0。先读[数据库设计](../../docs/database/README.md)和[完整字段字典](../../docs/database/字段字典.md)。脚本已在独立 MySQL 8.3 验证库执行通过；应用库 gc_system 已备份并应用 V001–V007，当前 47 表，未导入 D001。

## 执行顺序

在全新环境按以下顺序执行：

1. `create-database.sql.example`：创建开发库 `gc_system`，已有同名库会报错。
2. 选择目标库后执行 `upstream/ry_20260417.sql`：若依系统表、菜单及演示数据。
3. 执行 `upstream/quartz.sql`：Quartz 表。
4. 执行 `migrations/V001__create_mall_tables.sql`：14 张商城业务表及 `mall_schema_history`，169 个字段；全部完成后记录 V001。
5. 执行 `migrations/V002__register_order_expiry_job.sql`：注册每分钟的 Quartz 超时关单。
6. 执行 `migrations/V003__register_admin_menus.sql`：七个后台页面路由及按钮权限，不给普通角色自动授权。
7. 执行 `migrations/V004__customize_admin_brand.sql`：移除默认官网菜单、商城菜单前置，替换未修改的默认昵称、组织和公告；账号及业务记录不删除。
8. 执行 `migrations/V005__prune_admin_menus.sql`：移除部门、岗位、系统监控、系统工具及全部后代菜单/按钮和角色关联，不删除基础数据或定时任务；配套前端已移除两条附属路由。
9. 执行 `migrations/V006__game_servers.sql`：区服表、已有游戏的默认区服及后台页面/按钮权限；不改写历史交付信息。
10. 需要演示样本时，在 V007 之前执行 `demo/D001__mall_demo.sql`：固定 ID 的开发演示数据；不是生产初始化的必要步骤。
11. 执行 `migrations/V007__ruoyi_storefront_identity.sql`：迁移历史账号至若依，绑定商城档案，普通角色仅允许商城访问。

若依两份上游脚本包含 `DROP TABLE`，只能导入空库。已有若依应用库只执行尚未应用的商城增量脚本，不能重跑上游基线。V001 没有 DROP、TRUNCATE 或 sys_* 变更；MySQL DDL 隐式提交，出现错误后停止并核对已创建对象，不通过删库重建处理失败。

从 `system` 工作目录进入客户端，密码交互输入，不写进命令或脚本：

```powershell
mysql --default-character-set=utf8mb4 --abort-source-on-error -h 127.0.0.1 -P 3306 -u root -p gc_system
```

确认所选库正确、商城表不存在且已完成备份后，在客户端执行：

```sql
SELECT DATABASE();
SHOW TABLES LIKE 'mall_%';
SOURCE sql/migrations/V001__create_mall_tables.sql;
SOURCE sql/migrations/V002__register_order_expiry_job.sql;
SOURCE sql/migrations/V003__register_admin_menus.sql;
SOURCE sql/migrations/V004__customize_admin_brand.sql;
SOURCE sql/migrations/V005__prune_admin_menus.sql;
SOURCE sql/migrations/V006__game_servers.sql;
-- 仅需要开发样本时执行下一行，禁止重复导入。
SOURCE sql/demo/D001__mall_demo.sql;
SOURCE sql/migrations/V007__ruoyi_storefront_identity.sql;
SELECT * FROM mall_schema_history;
```

目标 MySQL 至少为 8.0.16，需要强制执行 CHECK；本机实际验证为 8.3.0，目标 8.0 仍需复核。先选择数据库；迁移不自动 CREATE DATABASE 或 USE，避免误选应用库。升级另建新版本，已应用迁移不得改写。V003 只增加商城菜单和按钮权限，V001 不覆盖若依菜单。V004 先备份再执行；只匹配原始默认值，自定义菜单、昵称和公告不覆盖，重复执行已验证。

V005 按根目录 `monitor/tool` 和系统管理下的 `dept/post` 定位，再递归收集后代；只删除这些菜单及角色关联。不要修改已应用的 V003 或重导上游 SQL 恢复已移除菜单。旧浏览器页面刷新后重新获取路由；移除的管理页面进入 404，后台接口和部门/岗位等基础数据仍由现有账号与业务使用。

应用库另经用户授权导入了 `display-catalog-v1` 显示数据，采用正式上传/创建接口建立图片元数据、商品及初始库存流水，属于业务展示数据。包含 3 分类、6 商品、3 轮播和 7 个本地图片文件，详见[素材和断点导入说明](../assets/display-catalog/README.md)。D001 仍只供隔离场景使用；不要为了添加图片向现有应用库重复导入 D001 或上游基线。

V006只在首次迁移为当时已有游戏建立默认区服。若D001在V006之后导入，请手动为演示游戏添加区服；隔离测试先D001再V006。详见[区服接口与兼容说明](../../docs/api/游戏区服管理与结算.md)。

## 演示场景

演示数据只对首次 V001 的空商城表执行，使用普通 INSERT 和事务；ID 或唯一键冲突时停止，不用 IGNORE/REPLACE 掩盖已有数据。两位演示会员 `demo_member`、`other_member` 的公开测试密码均为 `Example123!`，SQL 只保存 cost=12 的 BCrypt 散列。不要用于真实账号。

| 数据 | 演示值或用途 |
| --- | --- |
| 会员 2001 | demo_member；购物车、订单、可评价明细归属此会员 |
| 会员 2002 | other_member；用于验证越权与已评价场景 |
| 分类 101 / 商品 1001 | 星海远征 / 星辉长剑，price=49.90，stock=8，sales=5，version=9 |
| 购物车 4001 | 会员 2001，商品 1001，数量 2，已勾选 |
| 订单 5001 / 明细 50011 | 会员 2001，数量 2，待支付，30 分钟后过期 |
| 订单 5002 / 明细 50021 | 会员 2001，数量 1，已支付，待后台交付 |
| 订单 5003 / 明细 50031 | 会员 2001，数量 3，已完成，尚未评价 |
| 订单 5004 / 明细 50041 | 会员 2001，数量 1，已取消，库存已回补 |
| 订单 5005 / 明细 50051 | 会员 2002，数量 1，已完成，已有可见评价 7001 |
| 库存日志 8001–8007 | 从初始 15，扣单/取消回补后为 8；成功支付销量合计 5 |

SQL 以执行时刻统一平移时间，不会刚导入就让待支付订单过期；接口 JSON 固定示例时钟，Mock 时应统一时间偏移。接口中支付、取消、库存调整、发表评价的返回值表示各自独立动作后的状态，不要求导入后的数据库同时处于所有示例状态。

媒体 9001 只是占位元数据，脚本不附带真实图片文件；页面 Mock 应准备本地占位资源。真实联调时经正式上传接口创建文件/元数据，再通过业务接口更新对应图片引用，不能把元数据存在当作图片文件可访问的证明。

上游来源和提交见[上游源码记录](../../docs/上游源码记录.md)，隔离执行及约束检查记录见[数据库校验结果](../../docs/database/validation-result.json)。
