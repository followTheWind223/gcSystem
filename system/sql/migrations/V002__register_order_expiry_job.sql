-- 在 V001 与若依基线之后执行；只增加商城任务，不修改既有任务。
-- Quartz 的启动初始化从 sys_job 注册，重启后每分钟补扫已到期订单。
SET NAMES utf8mb4;
START TRANSACTION;
INSERT INTO sys_job(job_name,job_group,invoke_target,cron_expression,misfire_policy,concurrent,status,create_by,create_time,remark)
SELECT '游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','0 * * * * ?','2','1','0','migration',CURRENT_TIMESTAMP,'复用订单取消服务，逐单事务，状态竞争与库存回补幂等'
WHERE NOT EXISTS(SELECT 1 FROM sys_job WHERE invoke_target='gameshopOrderExpiry.closeExpired()');
INSERT INTO mall_schema_history(version,script_name,description)
VALUES ('V002','V002__register_order_expiry_job.sql','注册每分钟的 Quartz 商城超时关单任务');
COMMIT;
