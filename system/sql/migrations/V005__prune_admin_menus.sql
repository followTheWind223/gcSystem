-- V005：按用户要求精简后台菜单及路由来源。
-- 删除部门管理、岗位管理、系统监控、系统工具及全部后代（含按钮）的菜单和角色关联。
-- 不删除部门/岗位/账号/日志/任务的基础数据；商城 Quartz 关单继续运行。
-- 执行前备份应用库，执行失败回滚事务；前端需同时移除 JobLog、GenEdit 两条静态附属路由。
SET NAMES utf8mb4;
DROP TEMPORARY TABLE IF EXISTS gameshop_pruned_menu_ids;
CREATE TEMPORARY TABLE gameshop_pruned_menu_ids (menu_id BIGINT PRIMARY KEY);
START TRANSACTION;

INSERT INTO gameshop_pruned_menu_ids(menu_id)
WITH RECURSIVE pruned_tree AS (
    SELECT m.menu_id
    FROM sys_menu m
    LEFT JOIN sys_menu parent ON parent.menu_id=m.parent_id
    WHERE (m.parent_id=0 AND m.path IN ('monitor','tool'))
       OR (parent.parent_id=0 AND parent.path='system' AND m.path IN ('dept','post'))
    UNION ALL
    SELECT child.menu_id
    FROM sys_menu child
    INNER JOIN pruned_tree parent ON child.parent_id=parent.menu_id
)
SELECT menu_id FROM pruned_tree;

DELETE relation FROM sys_role_menu relation
INNER JOIN gameshop_pruned_menu_ids target ON target.menu_id=relation.menu_id;
DELETE menu FROM sys_menu menu
INNER JOIN gameshop_pruned_menu_ids target ON target.menu_id=menu.menu_id;

INSERT INTO mall_schema_history(version,script_name,description)
SELECT 'V005','V005__prune_admin_menus.sql','移除部门岗位、系统监控和系统工具的菜单、后代与角色关联'
WHERE NOT EXISTS (SELECT 1 FROM mall_schema_history WHERE version='V005');
COMMIT;
DROP TEMPORARY TABLE gameshop_pruned_menu_ids;
