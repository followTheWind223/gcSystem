-- V004：商城后台展示内容。只匹配未修改的上游默认值，不调整账号、角色或业务数据。
-- 应用前备份。保留源代码 LICENSE、版权声明及上游来源文档。
SET NAMES utf8mb4;
START TRANSACTION;

-- 移除没有子菜单的默认官网宣传入口及其角色关联；自定义入口不受影响。
SET @legacy_promo_menu = (
  SELECT m.menu_id FROM sys_menu m
  WHERE m.menu_id=4 AND m.parent_id=0 AND m.menu_name='若依官网'
    AND m.path IN ('http://ruoyi.vip','https://ruoyi.vip')
    AND NOT EXISTS (SELECT 1 FROM sys_menu child WHERE child.parent_id=m.menu_id)
  LIMIT 1
);
DELETE FROM sys_role_menu WHERE menu_id=@legacy_promo_menu;
DELETE FROM sys_menu WHERE menu_id=@legacy_promo_menu;
UPDATE sys_menu SET order_num=0,update_by='migration',update_time=CURRENT_TIMESTAMP
WHERE parent_id=0 AND path='gameshop' AND menu_name='游戏商城' AND order_num=4;

UPDATE sys_user SET nick_name='商城管理员',update_by='migration',update_time=CURRENT_TIMESTAMP
WHERE user_id=1 AND user_name='admin' AND nick_name='若依';
UPDATE sys_user SET nick_name='商城运营',update_by='migration',update_time=CURRENT_TIMESTAMP
WHERE user_id=2 AND user_name='ry' AND nick_name='若依';

-- 保留部门层级和归属，仅替换模板组织名称及联系人显示。
UPDATE sys_dept SET dept_name='商城运营中心',update_by='migration',update_time=CURRENT_TIMESTAMP
WHERE dept_id=100 AND dept_name='若依科技';
UPDATE sys_dept SET dept_name='商品运营组',update_by='migration',update_time=CURRENT_TIMESTAMP
WHERE dept_id=101 AND dept_name='深圳总公司';
UPDATE sys_dept SET dept_name='订单服务组',update_by='migration',update_time=CURRENT_TIMESTAMP
WHERE dept_id=102 AND dept_name='长沙分公司';
UPDATE sys_dept SET leader='商城管理员',email=NULL,update_by='migration',update_time=CURRENT_TIMESTAMP
WHERE dept_id BETWEEN 100 AND 109 AND leader='若依' AND email='ry@qq.com';

-- 保留通知 ID 和已读记录；只替换原始演示标题和内容完全匹配的公告。
UPDATE sys_notice SET notice_title='商品上架检查',notice_content='<p>发布游戏道具前，请核对分类、价格、可售库存与交付说明，确认无误后再上架。</p>',update_by='migration',update_time=CURRENT_TIMESTAMP
WHERE notice_id=1 AND notice_title='温馨提醒：2018-07-01 若依新版本发布啦' AND CONVERT(notice_content USING utf8mb4)='新版本内容';
UPDATE sys_notice SET notice_title='订单交付提醒',notice_content='<p>已支付订单请及时处理。完成游戏道具交付后，在商城订单中登记交付记录，再完成订单。</p>',update_by='migration',update_time=CURRENT_TIMESTAMP
WHERE notice_id=2 AND notice_title='维护通知：2018-07-01 若依系统凌晨维护' AND CONVERT(notice_content USING utf8mb4)='维护内容';
UPDATE sys_notice SET notice_title='商城管理操作指引',notice_content='<p>欢迎使用游戏道具商城管理中心。</p><p>在游戏商城菜单中维护游戏分类、道具商品和首页轮播，处理订单、管理会员与评价，并通过库存流水核对每次库存变化。</p>',update_by='migration',update_time=CURRENT_TIMESTAMP
WHERE notice_id=3 AND notice_title='若依开源框架介绍' AND CONVERT(notice_content USING utf8mb4) LIKE '%RuoYi开源项目%';

INSERT INTO mall_schema_history(version,script_name,description)
SELECT 'V004','V004__customize_admin_brand.sql','替换商城后台默认展示、组织和公告，移除官网宣传菜单'
WHERE NOT EXISTS (SELECT 1 FROM mall_schema_history WHERE version='V004');
COMMIT;
