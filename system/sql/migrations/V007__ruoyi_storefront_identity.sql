-- V007：统一使用若依账号认证；执行前备份，已执行版本由迁移工具跳过。
-- 保留 mall_member 主键及所有订单/购物车/评价引用，不按相同数字 ID 绑定账号。
SET NAMES utf8mb4;
CREATE TEMPORARY TABLE auth_migration_guard (ok INT CHECK (ok=1));
-- 同名账号无法证明属于同一人时必须人工处理，不自动合并。
INSERT INTO auth_migration_guard SELECT IF(
  NOT EXISTS(SELECT 1 FROM mall_member m JOIN sys_user u ON CONVERT(m.username USING utf8mb4) COLLATE utf8mb4_unicode_ci=u.user_name COLLATE utf8mb4_unicode_ci)
  AND NOT EXISTS(SELECT 1 FROM sys_user GROUP BY user_name HAVING COUNT(*)>1)
  AND (SELECT COUNT(*) FROM sys_role WHERE role_key='common' AND del_flag='0')=1, 1, 0);
DROP TEMPORARY TABLE auth_migration_guard;

ALTER TABLE sys_user ADD UNIQUE KEY uk_sys_user_name(user_name), MODIFY email VARCHAR(254) DEFAULT '', MODIFY phonenumber VARCHAR(20) DEFAULT '';
ALTER TABLE mall_member
  ADD sys_user_id BIGINT NULL COMMENT '唯一关联若依账号；商城只保存业务档案',
  ADD UNIQUE KEY uk_member_sys_user(sys_user_id),
  ADD CONSTRAINT fk_member_sys_user FOREIGN KEY(sys_user_id) REFERENCES sys_user(user_id),
  DROP CHECK ck_member_username,
  MODIFY username VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  MODIFY password_hash CHAR(60) CHARACTER SET ascii COLLATE ascii_bin NULL COMMENT 'V007后不再保存密码；认证统一在sys_user',
  MODIFY email VARCHAR(254) COLLATE utf8mb4_bin NULL,
  DROP INDEX uk_member_email;

START TRANSACTION;
SET @customer_role=(SELECT role_id FROM sys_role WHERE role_key='common' AND del_flag='0');
UPDATE sys_role SET role_name='普通用户',data_scope='5',status='0',update_by='migration',update_time=NOW(),remark='仅限商城用户端；公开注册默认角色' WHERE role_id=@customer_role;
DELETE FROM sys_role_menu WHERE role_id=@customer_role;
DELETE FROM sys_role_dept WHERE role_id=@customer_role;
INSERT INTO sys_user(user_name,nick_name,email,phonenumber,password,status,del_flag,pwd_update_date,create_by,create_time,remark)
SELECT username,nickname,email,COALESCE(phone_number,''),password_hash,status,'0',NOW(),'mall-auth-v007',create_time,'商城历史账号迁移；保留原密码'
FROM mall_member;
UPDATE mall_member m JOIN sys_user u ON CONVERT(m.username USING utf8mb4) COLLATE utf8mb4_unicode_ci=u.user_name COLLATE utf8mb4_unicode_ci
SET m.sys_user_id=u.user_id, m.password_hash=NULL, m.session_version=m.session_version+1;
INSERT INTO sys_user_role(user_id,role_id) SELECT sys_user_id,@customer_role FROM mall_member;
UPDATE sys_config SET config_value='true',update_by='migration',update_time=NOW() WHERE config_key='sys.account.registerUser';
INSERT INTO sys_config(config_name,config_key,config_value,config_type,create_by,create_time)
SELECT '账号自助注册','sys.account.registerUser','true','Y','migration',NOW()
WHERE NOT EXISTS(SELECT 1 FROM sys_config WHERE config_key='sys.account.registerUser');
COMMIT;
ALTER TABLE mall_member MODIFY sys_user_id BIGINT NOT NULL COMMENT '唯一关联若依账号；商城只保存业务档案';
INSERT INTO mall_schema_history(version,script_name,description) VALUES('V007','V007__ruoyi_storefront_identity.sql','商城统一若依认证、普通用户角色与历史账号迁移');
