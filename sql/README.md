# 完整数据库迁移备份

本目录保存 **2026-10-23 01:39:35（Asia/Shanghai）** 的 `gc_system` 完整快照，包含当时全部现有数据。结构版本为 **V007**，共 **47 张表、470 条记录**。这是固定时间的备份，后续新增或修改的数据需要重新导出。

| 文件 | 内容 |
| --- | --- |
| [gc_system_full.sql](./gc_system_full.sql) | 全部表结构及数据，包括账号密码散列、角色菜单、商品、订单、购物车、系统配置、日志、Quartz 与迁移记录 |
| [uploads.zip](./uploads.zip) | 7 个现有上传图片，包含 `uploads/` 目录及其内部层级 |
| [校验结果.json](./校验结果.json) | 逐表行数、文件 SHA-256 和恢复验证结果 |

备份已在独立临时空库中成功导入，逐表核对全部数据行和结构一致，临时验证库已清理。目标环境仍需使用与该快照匹配的当前项目代码。

## 恢复步骤

1. 准备 MySQL 8.0.16 或更高版本；源库与恢复验证环境均为 MySQL 8.3.0。停止目标环境后端，避免恢复过程中写入。
2. 将本目录复制到目标机器，使用 MySQL 客户端连接目标实例，密码交互输入：

   ```powershell
   mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p
   ```

3. 在 MySQL 客户端执行下面一条 `SOURCE` 命令，路径改成文件的实际位置：

   ```sql
   SOURCE D:/游戏商城系统/gcSystem/sql/gc_system_full.sql;
   ```

   Linux 示例：`SOURCE /srv/gcSystem/sql/gc_system_full.sql;`。文件包含 `CREATE DATABASE`、`USE gc_system` 和 `DROP TABLE IF EXISTS`，会替换目标 `gc_system` 中的同名表；应导入空环境或确认可以覆盖的目标库。

4. 将 `uploads.zip` 解压到后端 `system/data/`，使图片最终位于 `system/data/uploads/`。若 `UPLOAD_PATH` 指向其他目录，将压缩包中 `uploads/` 的内容放到该目录，保持相对路径不变。SQL 只保存图片元数据和路径，实际图片由此压缩包提供。
5. 按 `system/.env.example` 配置目标 `system/.env`，填写目标 MySQL、Redis、`TOKEN_SECRET` 及上传路径。SQL 不包含 MySQL 系统账号、数据库连接密码或环境文件，目标数据库访问账号需要在目标实例配置。
6. 启动与此快照匹配的后端及两端前端。备份已包含 V001–V007，**不要再次执行上游建表、增量迁移或 D001 演示数据脚本**。
7. 原有账号密码仍可使用。Redis 会话不在 SQL 中，迁移后需重新登录；目标 Redis 应使用独立实例或空闲 DB。

## 文件校验

在本目录运行 PowerShell：

```powershell
Get-FileHash -LiteralPath ./gc_system_full.sql -Algorithm SHA256
Get-FileHash -LiteralPath ./uploads.zip -Algorithm SHA256
```

将结果与 [校验结果.json](./校验结果.json) 的 `sqlSha256`、`uploadsSha256` 对比。

从零初始化数据库的上游及增量脚本仍位于 [system/sql/](../system/sql/README.md)；该流程与本目录的完整快照恢复分别使用。
