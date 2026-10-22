-- V006：游戏区服与后台管理入口。先备份再执行，不变更既有订单交付快照。
SET NAMES utf8mb4;
CREATE TABLE IF NOT EXISTS mall_game_server (
  server_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '区服ID',
  category_id BIGINT NOT NULL COMMENT '所属游戏分类',
  name VARCHAR(50) NOT NULL COMMENT '游戏内区服名称',
  sort INT NOT NULL DEFAULT 0,
  status CHAR(1) NOT NULL DEFAULT '1' COMMENT '0停用，1启用',
  remark VARCHAR(200) NULL,
  version INT NOT NULL DEFAULT 0,
  del_flag CHAR(1) NOT NULL DEFAULT '0' COMMENT '0正常，2软删除',
  active_name VARCHAR(50) GENERATED ALWAYS AS (CASE WHEN del_flag='0' THEN name ELSE NULL END) STORED,
  create_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  update_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  create_by VARCHAR(64) NOT NULL,
  update_by VARCHAR(64) NOT NULL,
  PRIMARY KEY(server_id),
  UNIQUE KEY uk_server_category_name(category_id,active_name),
  KEY idx_server_category_status(category_id,del_flag,status,sort,server_id),
  CONSTRAINT fk_server_category FOREIGN KEY(category_id) REFERENCES mall_game_category(category_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT ck_server_fields CHECK(CHAR_LENGTH(TRIM(name)) BETWEEN 1 AND 50 AND sort BETWEEN 0 AND 9999 AND version>=0 AND status IN ('0','1') AND del_flag IN ('0','2'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='按游戏维护的区服';
START TRANSACTION;
-- 仅首次迁移给已有游戏配置示例区服；以后人工删除/停用的配置不会被重跑脚本恢复。
INSERT INTO mall_game_server(category_id,name,sort,status,remark,create_by,update_by)
SELECT c.category_id,z.name,z.sort,'1','初始展示区服，可在后台调整','migration','migration'
FROM mall_game_category c CROSS JOIN (SELECT '一区' name,10 sort UNION ALL SELECT '二区',20 UNION ALL SELECT '三区',30) z
WHERE c.del_flag='0' AND NOT EXISTS(SELECT 1 FROM mall_schema_history WHERE version='V006')
AND NOT EXISTS(SELECT 1 FROM mall_game_server s WHERE s.category_id=c.category_id AND s.active_name=z.name);
SET @gameshop_root=(SELECT menu_id FROM sys_menu WHERE parent_id=0 AND path='gameshop' LIMIT 1);
INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,route_name,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time)
SELECT '游戏区服',@gameshop_root,8,'game-servers','gameshop/game-servers/index','GameshopGameServers',1,1,'C','0','0','mall:server:list','tree','migration',CURRENT_TIMESTAMP
WHERE @gameshop_root IS NOT NULL AND NOT EXISTS(SELECT 1 FROM sys_menu WHERE parent_id=@gameshop_root AND path='game-servers');
SET @gameshop_servers=(SELECT menu_id FROM sys_menu WHERE parent_id=@gameshop_root AND path='game-servers' LIMIT 1);
INSERT INTO sys_menu(menu_name,parent_id,order_num,path,component,route_name,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time)
SELECT p.label,@gameshop_servers,p.sort,'','','',1,1,'F','0','0',p.perm,'#','migration',CURRENT_TIMESTAMP
FROM (SELECT '区服查询' label,1 sort,'mall:server:query' perm UNION ALL SELECT '区服新增',2,'mall:server:add' UNION ALL SELECT '区服修改',3,'mall:server:edit' UNION ALL SELECT '区服删除',4,'mall:server:remove') p
WHERE @gameshop_servers IS NOT NULL AND NOT EXISTS(SELECT 1 FROM sys_menu m WHERE m.parent_id=@gameshop_servers AND m.perms=p.perm);
INSERT INTO mall_schema_history(version,script_name,description)
SELECT 'V006','V006__game_servers.sql','游戏区服、分类关联、默认区服与后台页面及按钮权限'
WHERE NOT EXISTS(SELECT 1 FROM mall_schema_history WHERE version='V006');
COMMIT;
