-- MySQL dump 10.13  Distrib 8.3.0, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: gc_system
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `gc_system`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `gc_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `gc_system`;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int DEFAULT '1' COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--
-- ORDER BY:  `table_id`

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--
-- ORDER BY:  `column_id`

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_banner`
--

DROP TABLE IF EXISTS `mall_banner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_banner` (
  `banner_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `title` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '1–60 字符标题',
  `image_media_id` bigint NOT NULL COMMENT '轮播图媒体',
  `target_prop_id` bigint NOT NULL COMMENT '内部目标商品，不允许任意外链',
  `sort` int NOT NULL DEFAULT '0' COMMENT '0–9999 排序值',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '0 停用/下架，1 启用/上架',
  `version` int NOT NULL DEFAULT '0' COMMENT '乐观锁版本；插入为 0，每次合法修改递增；库存操作也递增商品版本',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '0 正常，2 软删除；公开查询必须过滤为 0',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '创建操作者账号快照，不作为鉴权依据',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '最后修改操作者账号快照',
  PRIMARY KEY (`banner_id`),
  KEY `idx_banner_portal` (`del_flag`,`status`,`sort`,`banner_id`),
  KEY `fk_banner_image` (`image_media_id`),
  KEY `fk_banner_target` (`target_prop_id`),
  CONSTRAINT `fk_banner_image` FOREIGN KEY (`image_media_id`) REFERENCES `mall_media` (`media_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_banner_target` FOREIGN KEY (`target_prop_id`) REFERENCES `mall_prop` (`prop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_banner_values` CHECK (((char_length(`title`) between 1 and 60) and (`sort` between 0 and 9999) and (`version` >= 0) and (`status` in (_utf8mb4'0',_utf8mb4'1')) and (`del_flag` in (_utf8mb4'0',_utf8mb4'2')) and ((`del_flag` = _utf8mb4'0') or (`status` = _utf8mb4'0'))))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='首页内部商品轮播';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_banner`
--
-- ORDER BY:  `banner_id`,`del_flag`,`status`,`sort`,`banner_id`,`image_media_id`,`target_prop_id`

LOCK TABLES `mall_banner` WRITE;
/*!40000 ALTER TABLE `mall_banner` DISABLE KEYS */;
INSERT INTO `mall_banner` (`banner_id`, `title`, `image_media_id`, `target_prop_id`, `sort`, `status`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (1,'星海远征 · 星辉长剑',4,1,10,'1',0,'0','2026-10-22 23:29:54.210','2026-10-22 23:29:54.210','admin','admin');
INSERT INTO `mall_banner` (`banner_id`, `title`, `image_media_id`, `target_prop_id`, `sort`, `status`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (2,'永恒之境 · 星蝶护符',1,3,20,'1',0,'0','2026-10-22 23:29:54.223','2026-10-22 23:29:54.223','admin','admin');
INSERT INTO `mall_banner` (`banner_id`, `title`, `image_media_id`, `target_prop_id`, `sort`, `status`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (3,'机甲前线 · 先驱战术装备',7,6,30,'1',0,'0','2026-10-22 23:29:54.232','2026-10-22 23:29:54.232','admin','admin');
/*!40000 ALTER TABLE `mall_banner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_cart_item`
--

DROP TABLE IF EXISTS `mall_cart_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_cart_item` (
  `cart_item_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `member_id` bigint NOT NULL COMMENT '会员归属，只从认证上下文取得',
  `prop_id` bigint NOT NULL COMMENT '关联商品，失效时仍保留购物车行',
  `quantity` tinyint unsigned NOT NULL COMMENT '1–99，POST 是增量，PUT 是绝对值',
  `checked` tinyint NOT NULL DEFAULT '1' COMMENT '0 未勾选，1 勾选；不是结算的隐式范围',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  PRIMARY KEY (`cart_item_id`),
  UNIQUE KEY `uk_cart_member_prop` (`member_id`,`prop_id`),
  KEY `idx_cart_member_updated` (`member_id`,`update_time` DESC,`cart_item_id` DESC),
  KEY `fk_cart_prop` (`prop_id`),
  CONSTRAINT `fk_cart_member` FOREIGN KEY (`member_id`) REFERENCES `mall_member` (`member_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_cart_prop` FOREIGN KEY (`prop_id`) REFERENCES `mall_prop` (`prop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_cart_values` CHECK (((`quantity` between 1 and 99) and (`checked` in (0,1))))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='当前购物车项目';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_cart_item`
--
-- ORDER BY:  `cart_item_id`,`member_id`,`prop_id`,`member_id`,`update_time`,`cart_item_id`,`prop_id`

LOCK TABLES `mall_cart_item` WRITE;
/*!40000 ALTER TABLE `mall_cart_item` DISABLE KEYS */;
INSERT INTO `mall_cart_item` (`cart_item_id`, `member_id`, `prop_id`, `quantity`, `checked`, `create_time`, `update_time`) VALUES (1,1,3,2,1,'2026-10-22 23:58:26.323','2026-10-23 01:34:49.439');
INSERT INTO `mall_cart_item` (`cart_item_id`, `member_id`, `prop_id`, `quantity`, `checked`, `create_time`, `update_time`) VALUES (2,1,6,1,1,'2026-10-23 01:34:54.598','2026-10-23 01:34:54.598');
/*!40000 ALTER TABLE `mall_cart_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_game_category`
--

DROP TABLE IF EXISTS `mall_game_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_game_category` (
  `category_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'trim 后 2–30 字符；未删除分类中名称按 utf8mb4_unicode_ci 唯一',
  `icon_media_id` bigint DEFAULT NULL COMMENT '分类图标，可空',
  `sort` int NOT NULL DEFAULT '0' COMMENT '展示排序，0–9999，较小在前',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '0 停用/下架，1 启用/上架',
  `recommended` tinyint NOT NULL DEFAULT '0' COMMENT '0 普通，1 首页热门推荐',
  `version` int NOT NULL DEFAULT '0' COMMENT '乐观锁版本；插入为 0，每次合法修改递增；库存操作也递增商品版本',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '0 正常，2 软删除；公开查询必须过滤为 0',
  `active_name` varchar(30) COLLATE utf8mb4_unicode_ci GENERATED ALWAYS AS ((case when (`del_flag` = _utf8mb4'0') then `name` else NULL end)) STORED COMMENT '仅未删除行生成名称；软删除行生成 NULL，允许删除后重建同名分类',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '创建操作者账号快照，不作为鉴权依据',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '最后修改操作者账号快照',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uk_category_active_name` (`active_name`),
  KEY `idx_category_portal` (`del_flag`,`status`,`recommended`,`sort`,`category_id`),
  KEY `fk_category_icon` (`icon_media_id`),
  CONSTRAINT `fk_category_icon` FOREIGN KEY (`icon_media_id`) REFERENCES `mall_media` (`media_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_category_deleted` CHECK (((`del_flag` = _utf8mb4'0') or (`status` = _utf8mb4'0'))),
  CONSTRAINT `ck_category_name` CHECK ((char_length(`name`) between 2 and 30)),
  CONSTRAINT `ck_category_values` CHECK (((`status` in (_utf8mb4'0',_utf8mb4'1')) and (`del_flag` in (_utf8mb4'0',_utf8mb4'2')) and (`recommended` in (0,1)) and (`version` >= 0) and (`sort` between 0 and 9999)))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='单层游戏分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_game_category`
--
-- ORDER BY:  `category_id`,`active_name`,`del_flag`,`status`,`recommended`,`sort`,`category_id`,`icon_media_id`

LOCK TABLES `mall_game_category` WRITE;
/*!40000 ALTER TABLE `mall_game_category` DISABLE KEYS */;
INSERT INTO `mall_game_category` (`category_id`, `name`, `icon_media_id`, `sort`, `status`, `recommended`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (1,'星海远征',3,10,'1',1,0,'0','2026-10-22 23:29:53.914','2026-10-22 23:29:53.914','admin','admin');
INSERT INTO `mall_game_category` (`category_id`, `name`, `icon_media_id`, `sort`, `status`, `recommended`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (2,'永恒之境',5,20,'1',1,0,'0','2026-10-22 23:29:53.925','2026-10-22 23:29:53.925','admin','admin');
INSERT INTO `mall_game_category` (`category_id`, `name`, `icon_media_id`, `sort`, `status`, `recommended`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (3,'机甲前线',7,30,'1',1,0,'0','2026-10-22 23:29:53.933','2026-10-22 23:29:53.933','admin','admin');
/*!40000 ALTER TABLE `mall_game_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_game_server`
--

DROP TABLE IF EXISTS `mall_game_server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_game_server` (
  `server_id` bigint NOT NULL AUTO_INCREMENT COMMENT '区服ID',
  `category_id` bigint NOT NULL COMMENT '所属游戏分类',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏内区服名称',
  `sort` int NOT NULL DEFAULT '0',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '0停用，1启用',
  `remark` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `version` int NOT NULL DEFAULT '0',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '0正常，2软删除',
  `active_name` varchar(50) COLLATE utf8mb4_unicode_ci GENERATED ALWAYS AS ((case when (`del_flag` = _utf8mb4'0') then `name` else NULL end)) STORED,
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`server_id`),
  UNIQUE KEY `uk_server_category_name` (`category_id`,`active_name`),
  KEY `idx_server_category_status` (`category_id`,`del_flag`,`status`,`sort`,`server_id`),
  CONSTRAINT `fk_server_category` FOREIGN KEY (`category_id`) REFERENCES `mall_game_category` (`category_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_server_fields` CHECK (((char_length(trim(`name`)) between 1 and 50) and (`sort` between 0 and 9999) and (`version` >= 0) and (`status` in (_utf8mb4'0',_utf8mb4'1')) and (`del_flag` in (_utf8mb4'0',_utf8mb4'2'))))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='按游戏维护的区服';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_game_server`
--
-- ORDER BY:  `server_id`,`category_id`,`active_name`,`category_id`,`del_flag`,`status`,`sort`,`server_id`

LOCK TABLES `mall_game_server` WRITE;
/*!40000 ALTER TABLE `mall_game_server` DISABLE KEYS */;
INSERT INTO `mall_game_server` (`server_id`, `category_id`, `name`, `sort`, `status`, `remark`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (1,3,'一区',10,'1','初始展示区服，可在后台调整',0,'0','2026-10-23 00:17:43.885','2026-10-23 00:17:43.885','migration','migration');
INSERT INTO `mall_game_server` (`server_id`, `category_id`, `name`, `sort`, `status`, `remark`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (2,2,'一区',10,'1','初始展示区服，可在后台调整',0,'0','2026-10-23 00:17:43.885','2026-10-23 00:17:43.885','migration','migration');
INSERT INTO `mall_game_server` (`server_id`, `category_id`, `name`, `sort`, `status`, `remark`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (3,1,'一区',10,'1','初始展示区服，可在后台调整',0,'0','2026-10-23 00:17:43.885','2026-10-23 00:17:43.885','migration','migration');
INSERT INTO `mall_game_server` (`server_id`, `category_id`, `name`, `sort`, `status`, `remark`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (4,3,'二区',20,'1','初始展示区服，可在后台调整',0,'0','2026-10-23 00:17:43.885','2026-10-23 00:17:43.885','migration','migration');
INSERT INTO `mall_game_server` (`server_id`, `category_id`, `name`, `sort`, `status`, `remark`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (5,2,'二区',20,'1','初始展示区服，可在后台调整',0,'0','2026-10-23 00:17:43.885','2026-10-23 00:17:43.885','migration','migration');
INSERT INTO `mall_game_server` (`server_id`, `category_id`, `name`, `sort`, `status`, `remark`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (6,1,'二区',20,'1','初始展示区服，可在后台调整',0,'0','2026-10-23 00:17:43.885','2026-10-23 00:17:43.885','migration','migration');
INSERT INTO `mall_game_server` (`server_id`, `category_id`, `name`, `sort`, `status`, `remark`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (7,3,'三区',30,'1','初始展示区服，可在后台调整',0,'0','2026-10-23 00:17:43.885','2026-10-23 00:17:43.885','migration','migration');
INSERT INTO `mall_game_server` (`server_id`, `category_id`, `name`, `sort`, `status`, `remark`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (8,2,'三区',30,'1','初始展示区服，可在后台调整',0,'0','2026-10-23 00:17:43.885','2026-10-23 00:17:43.885','migration','migration');
INSERT INTO `mall_game_server` (`server_id`, `category_id`, `name`, `sort`, `status`, `remark`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (9,1,'三区',30,'1','初始展示区服，可在后台调整',0,'0','2026-10-23 00:17:43.885','2026-10-23 00:17:43.885','migration','migration');
/*!40000 ALTER TABLE `mall_game_server` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_media`
--

DROP TABLE IF EXISTS `mall_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_media` (
  `media_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `stored_name` varchar(37) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '32 位小写十六进制随机名加 .png/.jpg/.webp',
  `access_path` varchar(80) COLLATE utf8mb4_unicode_ci GENERATED ALWAYS AS (concat(_ascii'/api/mall/media/',`stored_name`)) STORED NOT NULL COMMENT '从文件名生成同源 URL，不保存域名或磁盘绝对路径',
  `relative_path` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '相对 UPLOAD_PATH 的服务器生成路径，例如 mall/2026/10/22/随机名.png；服务端规范化后必须在根目录内',
  `original_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '去除目录和控制字符后的原始文件名',
  `mime_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '重新编码后的实际 MIME：image/png、image/jpeg、image/webp',
  `file_size` int NOT NULL COMMENT '编码后字节数，1–5242880；头像额外限制为 2097152',
  `width` int NOT NULL COMMENT '图片宽度，1–4096 像素',
  `height` int NOT NULL COMMENT '图片高度，1–4096 像素',
  `sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '编码后文件 SHA-256；用于完整性核对，不作为唯一键',
  `uploader_type` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ADMIN 或 MEMBER；与 uploader_id 组成逻辑引用',
  `uploader_id` bigint NOT NULL COMMENT '按 uploader_type 关联 sys_user.user_id 或 mall_member.member_id，服务层验证，非物理外键',
  `uploader_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '上传者账号快照，账号之后更名/删除不改历史',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '上传完成时间',
  PRIMARY KEY (`media_id`),
  UNIQUE KEY `uk_media_name` (`stored_name`),
  UNIQUE KEY `uk_media_path` (`access_path`),
  KEY `idx_media_uploader` (`uploader_type`,`uploader_id`,`create_time`),
  CONSTRAINT `ck_media_limits` CHECK (((`file_size` between 1 and 5242880) and (`width` between 1 and 4096) and (`height` between 1 and 4096))),
  CONSTRAINT `ck_media_path` CHECK ((`relative_path` like _utf8mb4'mall/%')),
  CONSTRAINT `ck_media_type` CHECK ((`mime_type` in (_utf8mb4'image/png',_utf8mb4'image/jpeg',_utf8mb4'image/webp'))),
  CONSTRAINT `ck_media_uploader` CHECK (((`uploader_type` in (_utf8mb4'ADMIN',_utf8mb4'MEMBER')) and (`uploader_id` > 0)))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商城受控公开图片';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_media`
--
-- ORDER BY:  `media_id`,`stored_name`,`access_path`,`uploader_type`,`uploader_id`,`create_time`

LOCK TABLES `mall_media` WRITE;
/*!40000 ALTER TABLE `mall_media` DISABLE KEYS */;
INSERT INTO `mall_media` (`media_id`, `stored_name`, `relative_path`, `original_name`, `mime_type`, `file_size`, `width`, `height`, `sha256`, `uploader_type`, `uploader_id`, `uploader_name`, `create_time`) VALUES (1,'81760a5128d34ca3bf6cba8b8205a8db.png','mall/2026/10/22/81760a5128d34ca3bf6cba8b8205a8db.png','astral-charm.png','image/png',2345273,1254,1254,'acfb54e36b816ce8e776cbacea13742aafdddb6d6174f66a46b540a850aec5c5','ADMIN',1,'admin','2026-10-22 23:29:52.386');
INSERT INTO `mall_media` (`media_id`, `stored_name`, `relative_path`, `original_name`, `mime_type`, `file_size`, `width`, `height`, `sha256`, `uploader_type`, `uploader_id`, `uploader_name`, `create_time`) VALUES (2,'a05a1d3d258c4c49ae389121e301f995.png','mall/2026/10/22/a05a1d3d258c4c49ae389121e301f995.png','frost-crystal.png','image/png',2629539,1254,1254,'cb015a8f80934cda7b957ffaf2bbcde27df2c0b2b1d81d64e8e69be43397ec3e','ADMIN',1,'admin','2026-10-22 23:29:52.651');
INSERT INTO `mall_media` (`media_id`, `stored_name`, `relative_path`, `original_name`, `mime_type`, `file_size`, `width`, `height`, `sha256`, `uploader_type`, `uploader_id`, `uploader_name`, `create_time`) VALUES (3,'c513bbc770584534900367663e08334c.png','mall/2026/10/22/c513bbc770584534900367663e08334c.png','starblade.png','image/png',2128440,1254,1254,'f4752e88e2a3e847a70b7c67b84ed8b41b1afb03c1b664bcf3b551077e412d9b','ADMIN',1,'admin','2026-10-22 23:29:52.909');
INSERT INTO `mall_media` (`media_id`, `stored_name`, `relative_path`, `original_name`, `mime_type`, `file_size`, `width`, `height`, `sha256`, `uploader_type`, `uploader_id`, `uploader_name`, `create_time`) VALUES (4,'62f23482419b415a8fafb746bc149542.png','mall/2026/10/22/62f23482419b415a8fafb746bc149542.png','starblade-banner.png','image/png',2917733,1536,1024,'57cee819d6b5cd83f5da53880ce2ce95a26a9a8fc45060700cf09f53c9b61bc8','ADMIN',1,'admin','2026-10-22 23:29:53.185');
INSERT INTO `mall_media` (`media_id`, `stored_name`, `relative_path`, `original_name`, `mime_type`, `file_size`, `width`, `height`, `sha256`, `uploader_type`, `uploader_id`, `uploader_name`, `create_time`) VALUES (5,'440b9b64fc7a4d0e97a8ec278b034da4.png','mall/2026/10/22/440b9b64fc7a4d0e97a8ec278b034da4.png','sunbow.png','image/png',1798788,1254,1254,'5f2455c4cb590d718a21d742b95b4b0e275f450045859e650268e5be3517a57e','ADMIN',1,'admin','2026-10-22 23:29:53.414');
INSERT INTO `mall_media` (`media_id`, `stored_name`, `relative_path`, `original_name`, `mime_type`, `file_size`, `width`, `height`, `sha256`, `uploader_type`, `uploader_id`, `uploader_name`, `create_time`) VALUES (6,'38698866f5824cce9275ea5ea2bff919.png','mall/2026/10/22/38698866f5824cce9275ea5ea2bff919.png','supply-chest.png','image/png',2802526,1254,1254,'4ba77feceec7b03f5e700591b949cbc816c1f17d530fec11a318ff5ced8e16b7','ADMIN',1,'admin','2026-10-22 23:29:53.659');
INSERT INTO `mall_media` (`media_id`, `stored_name`, `relative_path`, `original_name`, `mime_type`, `file_size`, `width`, `height`, `sha256`, `uploader_type`, `uploader_id`, `uploader_name`, `create_time`) VALUES (7,'3229fecbb9da46da8a2879472e536fea.png','mall/2026/10/22/3229fecbb9da46da8a2879472e536fea.png','vanguard-helmet.png','image/png',2415162,1254,1254,'764740e1919ad13e1323aadd3ef021b9a5c3d4215d91d944c536b120b86acc16','ADMIN',1,'admin','2026-10-22 23:29:53.897');
/*!40000 ALTER TABLE `mall_media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_member`
--

DROP TABLE IF EXISTS `mall_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_member` (
  `member_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` char(60) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL COMMENT 'V007后不再保存密码；认证统一在sys_user',
  `nickname` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '2–30 字符的展示昵称，注册省略时采用 username',
  `avatar_media_id` bigint DEFAULT NULL COMMENT '头像关联受控媒体；默认无头像',
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `email_verified` tinyint NOT NULL DEFAULT '0' COMMENT '0 未验证，1 已验证；注册验码成功明确写 1',
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '可空联系方式；非空时 7–20 字符，格式由 DTO 校验',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '0 正常，1 禁用，与商品状态含义相反',
  `session_version` bigint NOT NULL DEFAULT '0' COMMENT '会话版本；禁用、改密和重置密码时递增，所有旧会话必须失效',
  `status_reason` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次启停原因；完整操作历史另留若依操作日志',
  `last_login_time` datetime(3) DEFAULT NULL COMMENT '最近成功登录时间，首次未登录为空',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  `sys_user_id` bigint NOT NULL COMMENT '唯一关联若依账号；商城只保存业务档案',
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `uk_member_username` (`username`),
  UNIQUE KEY `uk_member_sys_user` (`sys_user_id`),
  KEY `idx_member_status_time` (`status`,`create_time`,`member_id`),
  KEY `fk_member_avatar` (`avatar_media_id`),
  CONSTRAINT `fk_member_avatar` FOREIGN KEY (`avatar_media_id`) REFERENCES `mall_media` (`media_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_member_sys_user` FOREIGN KEY (`sys_user_id`) REFERENCES `sys_user` (`user_id`),
  CONSTRAINT `ck_member_disabled_reason` CHECK (((`status` = _utf8mb4'0') or ((`status_reason` is not null) and (char_length(`status_reason`) between 2 and 200)))),
  CONSTRAINT `ck_member_nickname` CHECK ((char_length(`nickname`) between 2 and 30)),
  CONSTRAINT `ck_member_status` CHECK (((`status` in (_utf8mb4'0',_utf8mb4'1')) and (`email_verified` in (0,1)) and (`session_version` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='独立商城会员';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_member`
--
-- ORDER BY:  `member_id`,`username`,`sys_user_id`,`status`,`create_time`,`member_id`,`avatar_media_id`

LOCK TABLES `mall_member` WRITE;
/*!40000 ALTER TABLE `mall_member` DISABLE KEYS */;
INSERT INTO `mall_member` (`member_id`, `username`, `password_hash`, `nickname`, `avatar_media_id`, `email`, `email_verified`, `phone_number`, `status`, `session_version`, `status_reason`, `last_login_time`, `create_time`, `update_time`, `sys_user_id`) VALUES (1,'mfenggg',NULL,'Mfenggg',NULL,'admin@qq.com',0,NULL,'0',1,NULL,'2026-10-23 00:44:37.795','2026-10-22 23:44:06.629','2026-10-23 01:11:36.990',100);
INSERT INTO `mall_member` (`member_id`, `username`, `password_hash`, `nickname`, `avatar_media_id`, `email`, `email_verified`, `phone_number`, `status`, `session_version`, `status_reason`, `last_login_time`, `create_time`, `update_time`, `sys_user_id`) VALUES (2,'admin',NULL,'商城管理员',NULL,'ry@163.com',0,'15888888888','0',0,NULL,NULL,'2026-10-23 01:13:07.302','2026-10-23 01:13:07.302',1);
/*!40000 ALTER TABLE `mall_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_order`
--

DROP TABLE IF EXISTS `mall_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_order` (
  `order_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `order_no` varchar(40) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '服务器生成的 16–40 位大写字母数字订单号，全局唯一',
  `member_id` bigint NOT NULL COMMENT '下单会员，构成订单归属；从认证上下文取得',
  `source` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'DIRECT 或 CART，来自报价快照',
  `request_key` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '规范化小写 UUID；同会员同键永不重复建单',
  `request_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '规范化 quoteToken/交付字段/备注的 SHA-256，仅用于精确重放，不保存原始令牌',
  `total_amount` decimal(12,2) NOT NULL COMMENT '各明细 subtotal 之和，大于 0，由服务端计算',
  `total_quantity` smallint unsigned NOT NULL COMMENT '各明细数量之和，1–4950',
  `item_count` tinyint unsigned NOT NULL COMMENT '不同商品明细行数，1–50',
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CNY' COMMENT '首版固定人民币',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '1 待支付，2 已支付，3 已取消，4 已完成',
  `delivery_info_json` json NOT NULL COMMENT '本单交付信息快照，三字段可空：gameAccount/serverName/roleName；禁止存游戏密码',
  `remark` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '买家备注，trim 后空白归 null',
  `cancel_reason` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '取消原因，取消状态必填',
  `expire_time` datetime(3) NOT NULL COMMENT '创建后默认 30 分钟，过期不可支付',
  `paid_time` datetime(3) DEFAULT NULL COMMENT '首次成功支付时间',
  `cancelled_time` datetime(3) DEFAULT NULL COMMENT '实际取消/关单时间',
  `completed_time` datetime(3) DEFAULT NULL COMMENT '登记交付并完成的时间',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  UNIQUE KEY `uk_order_member_request` (`member_id`,`request_key`),
  UNIQUE KEY `uk_order_owner` (`order_id`,`member_id`),
  KEY `idx_order_member_time` (`member_id`,`create_time` DESC,`order_id` DESC),
  KEY `idx_order_member_state_time` (`member_id`,`status`,`create_time` DESC,`order_id` DESC),
  KEY `idx_order_expiry` (`status`,`expire_time`,`order_id`),
  KEY `idx_order_admin_time` (`create_time` DESC,`order_id` DESC),
  CONSTRAINT `fk_order_member` FOREIGN KEY (`member_id`) REFERENCES `mall_member` (`member_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_order_money_counts` CHECK (((`total_amount` > 0) and (`total_quantity` between 1 and 4950) and (`item_count` between 1 and 50))),
  CONSTRAINT `ck_order_source` CHECK (((`source` in (_utf8mb4'DIRECT',_utf8mb4'CART')) and (`currency` = _utf8mb4'CNY') and (char_length(`request_key`) = 36) and (char_length(`request_hash`) = 64) and (json_type(`delivery_info_json`) = _utf8mb4'OBJECT'))),
  CONSTRAINT `ck_order_state_times` CHECK ((((`status` = _utf8mb4'1') and (`paid_time` is null) and (`cancelled_time` is null) and (`completed_time` is null)) or ((`status` = _utf8mb4'2') and (`paid_time` is not null) and (`cancelled_time` is null) and (`completed_time` is null)) or ((`status` = _utf8mb4'3') and (`paid_time` is null) and (`cancelled_time` is not null) and (`completed_time` is null) and (`cancel_reason` is not null)) or ((`status` = _utf8mb4'4') and (`paid_time` is not null) and (`cancelled_time` is null) and (`completed_time` is not null)))),
  CONSTRAINT `ck_order_time` CHECK (((`expire_time` > `create_time`) and ((`paid_time` is null) or ((`paid_time` >= `create_time`) and (`paid_time` < `expire_time`))) and ((`cancelled_time` is null) or (`cancelled_time` >= `create_time`)) and ((`completed_time` is null) or (`completed_time` >= `paid_time`))))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='不可物理删除的订单主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_order`
--
-- ORDER BY:  `order_id`,`order_no`,`member_id`,`request_key`,`order_id`,`member_id`,`member_id`,`create_time`,`order_id`,`member_id`,`status`,`create_time`,`order_id`,`status`,`expire_time`,`order_id`,`create_time`,`order_id`

LOCK TABLES `mall_order` WRITE;
/*!40000 ALTER TABLE `mall_order` DISABLE KEYS */;
INSERT INTO `mall_order` (`order_id`, `order_no`, `member_id`, `source`, `request_key`, `request_hash`, `total_amount`, `total_quantity`, `item_count`, `currency`, `status`, `delivery_info_json`, `remark`, `cancel_reason`, `expire_time`, `paid_time`, `cancelled_time`, `completed_time`, `create_time`, `update_time`) VALUES (1,'GC20261023004452833CC433AE96A71',1,'DIRECT','bc1b31fd-69f2-40d1-a748-51b930cebe44','a7930858b2e0a66fa6cd878e64de608a2ffcb43c80419f04b261caaab3c5bf69',159.00,1,1,'CNY','3','{\"servers\": [{\"serverId\": \"1\", \"categoryId\": \"3\", \"serverName\": \"一区\", \"categoryName\": \"机甲前线\"}], \"roleName\": \"mfenggg\", \"serverName\": \"一区\", \"gameAccount\": \"mfenggg666\"}',NULL,'超时未支付自动关闭','2026-10-23 01:14:52.835',NULL,'2026-10-23 01:15:00.007',NULL,'2026-10-23 00:44:52.837','2026-10-23 01:15:00.015');
/*!40000 ALTER TABLE `mall_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_order_delivery`
--

DROP TABLE IF EXISTS `mall_order_delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_order_delivery` (
  `delivery_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `order_id` bigint NOT NULL COMMENT '所属订单，一单至多一次完成交付',
  `delivery_note` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '2–1000 字符交付说明，购买会员可见，禁止游戏密码',
  `operator_admin_id` bigint NOT NULL COMMENT '后台操作者 ID，逻辑关联 sys_user；从认证上下文取得',
  `operator_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作者账号快照，防止后台账号后来删除导致历史丢失',
  `delivered_time` datetime(3) NOT NULL COMMENT '交付完成时间，与订单 completed_time 同值',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录落库时间',
  PRIMARY KEY (`delivery_id`),
  UNIQUE KEY `uk_delivery_order` (`order_id`),
  CONSTRAINT `fk_delivery_order` FOREIGN KEY (`order_id`) REFERENCES `mall_order` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_delivery_values` CHECK (((char_length(`delivery_note`) between 2 and 1000) and (`operator_admin_id` > 0)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='唯一虚拟交付事实';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_order_delivery`
--
-- ORDER BY:  `delivery_id`,`order_id`

LOCK TABLES `mall_order_delivery` WRITE;
/*!40000 ALTER TABLE `mall_order_delivery` DISABLE KEYS */;
/*!40000 ALTER TABLE `mall_order_delivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_order_item`
--

DROP TABLE IF EXISTS `mall_order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_order_item` (
  `order_item_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `order_id` bigint NOT NULL COMMENT '所属订单',
  `prop_id` bigint NOT NULL COMMENT '商品历史关联；软删除后仍保留',
  `prop_name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '下单时商品名称快照，不随改名变更',
  `cover_url` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '下单时受控图片 URL 快照',
  `spec_json` json NOT NULL COMMENT '下单时展示规格快照',
  `unit_price` decimal(12,2) NOT NULL COMMENT '下单时真实单价，不随调价变更',
  `quantity` tinyint unsigned NOT NULL COMMENT '1–99，合并后的购买数量',
  `subtotal` decimal(12,2) GENERATED ALWAYS AS ((`unit_price` * `quantity`)) STORED NOT NULL COMMENT '数据库生成列；INSERT/UPDATE 不允许赋值；服务端还需检查总额容量',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '快照创建时间',
  PRIMARY KEY (`order_item_id`),
  UNIQUE KEY `uk_order_item_prop` (`order_id`,`prop_id`),
  UNIQUE KEY `uk_order_item_identity` (`order_item_id`,`order_id`,`prop_id`),
  KEY `fk_item_prop` (`prop_id`),
  CONSTRAINT `fk_item_order` FOREIGN KEY (`order_id`) REFERENCES `mall_order` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_item_prop` FOREIGN KEY (`prop_id`) REFERENCES `mall_prop` (`prop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_order_item_values` CHECK (((`unit_price` > 0) and (`quantity` between 1 and 99) and (json_type(`spec_json`) = _utf8mb4'ARRAY')))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单商品不可变快照';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_order_item`
--
-- ORDER BY:  `order_item_id`,`order_id`,`prop_id`,`order_item_id`,`order_id`,`prop_id`,`prop_id`

LOCK TABLES `mall_order_item` WRITE;
/*!40000 ALTER TABLE `mall_order_item` DISABLE KEYS */;
INSERT INTO `mall_order_item` (`order_item_id`, `order_id`, `prop_id`, `prop_name`, `cover_url`, `spec_json`, `unit_price`, `quantity`, `create_time`) VALUES (1,1,6,'先驱战术头盔','/api/mall/media/3229fecbb9da46da8a2879472e536fea.png','[{\"name\": \"所属游戏\", \"value\": \"机甲前线\"}, {\"name\": \"道具类型\", \"value\": \"角色装备\"}, {\"name\": \"道具品质\", \"value\": \"传说\"}, {\"name\": \"交付方式\", \"value\": \"游戏内手动交付\"}]',159.00,1,'2026-10-23 00:44:52.840');
/*!40000 ALTER TABLE `mall_order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_order_log`
--

DROP TABLE IF EXISTS `mall_order_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_order_log` (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `order_id` bigint NOT NULL COMMENT '所属订单',
  `from_status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '初始建单为 null，否则是本次动作的旧状态',
  `to_status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '本次动作后的新状态',
  `operator_type` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ADMIN、MEMBER、SYSTEM，多态操作者类型',
  `operator_id` bigint DEFAULT NULL COMMENT '按类型逻辑关联 sys_user 或 mall_member；SYSTEM 必须 null',
  `operator_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '账号快照；SYSTEM 使用 system',
  `reason` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '动作说明；完整交付说明存交付表，取消原因同时存订单快照',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '状态变化时间',
  PRIMARY KEY (`log_id`),
  UNIQUE KEY `uk_order_log_state` (`order_id`,`to_status`),
  KEY `idx_order_log_timeline` (`order_id`,`create_time`,`log_id`),
  CONSTRAINT `fk_order_log_order` FOREIGN KEY (`order_id`) REFERENCES `mall_order` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_order_log_operator` CHECK ((((`operator_type` = _utf8mb4'SYSTEM') and (`operator_id` is null)) or ((`operator_type` in (_utf8mb4'ADMIN',_utf8mb4'MEMBER')) and (`operator_id` is not null) and (`operator_id` > 0)))),
  CONSTRAINT `ck_order_log_transition` CHECK ((((`from_status` is null) and (`to_status` = _utf8mb4'1')) or ((`from_status` = _utf8mb4'1') and (`to_status` in (_utf8mb4'2',_utf8mb4'3'))) or ((`from_status` = _utf8mb4'2') and (`to_status` = _utf8mb4'4'))))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='只追加订单状态流水';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_order_log`
--
-- ORDER BY:  `log_id`,`order_id`,`to_status`,`order_id`,`create_time`,`log_id`

LOCK TABLES `mall_order_log` WRITE;
/*!40000 ALTER TABLE `mall_order_log` DISABLE KEYS */;
INSERT INTO `mall_order_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operator_type`, `operator_id`, `operator_name`, `reason`, `create_time`) VALUES (1,1,NULL,'1','MEMBER',1,'mfenggg','创建订单','2026-10-23 00:44:52.845');
INSERT INTO `mall_order_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operator_type`, `operator_id`, `operator_name`, `reason`, `create_time`) VALUES (2,1,'1','3','SYSTEM',NULL,'system','超时未支付自动关闭','2026-10-23 01:15:00.027');
/*!40000 ALTER TABLE `mall_order_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_payment_record`
--

DROP TABLE IF EXISTS `mall_payment_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_payment_record` (
  `payment_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `order_id` bigint NOT NULL COMMENT '所属订单，一个订单至多一条成功支付',
  `payment_no` varchar(40) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '全局唯一成功支付编号',
  `channel` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MOCK' COMMENT '首版仅 MOCK',
  `amount` decimal(12,2) NOT NULL COMMENT '与订单快照金额相等，由支付事务校验',
  `paid_time` datetime(3) NOT NULL COMMENT '成功支付发生时间，与订单 paid_time 同值',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '事实落库时间',
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `uk_payment_order` (`order_id`),
  UNIQUE KEY `uk_payment_no` (`payment_no`),
  CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `mall_order` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_payment_values` CHECK (((`channel` = _utf8mb4'MOCK') and (`amount` > 0)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='唯一成功模拟支付事实';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_payment_record`
--
-- ORDER BY:  `payment_id`,`order_id`,`payment_no`

LOCK TABLES `mall_payment_record` WRITE;
/*!40000 ALTER TABLE `mall_payment_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `mall_payment_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_prop`
--

DROP TABLE IF EXISTS `mall_prop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_prop` (
  `prop_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `category_id` bigint NOT NULL COMMENT '所属分类，写入时必须是未删除分类',
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称，2–80 字符',
  `cover_media_id` bigint NOT NULL COMMENT '封面媒体，服务层保证也在图片列表中',
  `price` decimal(12,2) NOT NULL COMMENT '当前售价，大于 0；接口两位小数字符串',
  `original_price` decimal(12,2) DEFAULT NULL COMMENT '可空划线价，非空时不小于售价',
  `stock` int NOT NULL DEFAULT '0' COMMENT '当前可售库存，0–1000000000；下单扣减，取消回补，支付不再扣',
  `sales` int NOT NULL DEFAULT '0' COMMENT '成功支付的累计数量，只在首次支付成功时增加',
  `detail_html` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '清洗后的富文本，最多 20000 字符；MEDIUMTEXT 可容纳 utf8mb4 的完整字符容量',
  `spec_json` json NOT NULL COMMENT '最多 20 个 {name,value} 展示规格，不是 SKU',
  `delivery_fields_json` json NOT NULL COMMENT '1–3 个唯一字段名：gameAccount/serverName/roleName；枚举由服务层校验',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '0 停用/下架，1 启用/上架',
  `on_sale_time` datetime(3) DEFAULT NULL COMMENT '最近一次上架时间；从未上架可空，上架时必须有值',
  `version` int NOT NULL DEFAULT '0' COMMENT '乐观锁版本；插入为 0，每次合法修改递增；库存操作也递增商品版本',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '0 正常，2 软删除；公开查询必须过滤为 0',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '创建操作者账号快照，不作为鉴权依据',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '最后修改操作者账号快照',
  PRIMARY KEY (`prop_id`),
  KEY `idx_prop_new` (`del_flag`,`status`,`on_sale_time` DESC,`prop_id` DESC),
  KEY `idx_prop_category_new` (`category_id`,`del_flag`,`status`,`on_sale_time` DESC,`prop_id` DESC),
  KEY `idx_prop_price` (`del_flag`,`status`,`price`,`prop_id`),
  KEY `idx_prop_sales` (`del_flag`,`status`,`sales` DESC,`prop_id` DESC),
  KEY `fk_prop_cover` (`cover_media_id`),
  CONSTRAINT `fk_prop_category` FOREIGN KEY (`category_id`) REFERENCES `mall_game_category` (`category_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_prop_cover` FOREIGN KEY (`cover_media_id`) REFERENCES `mall_media` (`media_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_prop_json` CHECK (((json_type(`spec_json`) = _utf8mb4'ARRAY') and (json_length(`spec_json`) <= 20) and (json_type(`delivery_fields_json`) = _utf8mb4'ARRAY') and (json_length(`delivery_fields_json`) between 1 and 3))),
  CONSTRAINT `ck_prop_money` CHECK (((`price` > 0) and ((`original_price` is null) or (`original_price` >= `price`)))),
  CONSTRAINT `ck_prop_state` CHECK (((`status` in (_utf8mb4'0',_utf8mb4'1')) and (`del_flag` in (_utf8mb4'0',_utf8mb4'2')) and ((`status` = _utf8mb4'0') or (`on_sale_time` is not null)) and ((`del_flag` = _utf8mb4'0') or (`status` = _utf8mb4'0')))),
  CONSTRAINT `ck_prop_stock` CHECK (((`stock` between 0 and 1000000000) and (`sales` between 0 and 2147483647) and (`version` >= 0))),
  CONSTRAINT `ck_prop_text` CHECK (((char_length(`name`) between 2 and 80) and (char_length(`detail_html`) <= 20000)))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='单商品单库存道具';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_prop`
--
-- ORDER BY:  `prop_id`,`del_flag`,`status`,`on_sale_time`,`prop_id`,`category_id`,`del_flag`,`status`,`on_sale_time`,`prop_id`,`del_flag`,`status`,`price`,`prop_id`,`del_flag`,`status`,`sales`,`prop_id`,`cover_media_id`

LOCK TABLES `mall_prop` WRITE;
/*!40000 ALTER TABLE `mall_prop` DISABLE KEYS */;
INSERT INTO `mall_prop` (`prop_id`, `category_id`, `name`, `cover_media_id`, `price`, `original_price`, `stock`, `sales`, `detail_html`, `spec_json`, `delivery_fields_json`, `status`, `on_sale_time`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (1,1,'星辉长剑·青曜',3,129.00,199.00,25,0,'<h2>星辉长剑·青曜</h2>\n<p>银色剑身嵌入青曜晶核，流动的星辉沿刃面汇聚。适合星海远征中的近战角色，完整展示青色光效与金属纹理。</p>\n<p><img src=\"/api/mall/media/c513bbc770584534900367663e08334c.png\" alt=\"星辉长剑·青曜\"></p>\n<h3>交付说明</h3>\n<p>请填写游戏账号、区服和角色名称。支付后由管理员手动交付，请核对资料后下单。</p>\n<p>本商品为原创虚构游戏道具，用于商城演示。请勿填写游戏密码。</p>','[{\"name\": \"所属游戏\", \"value\": \"星海远征\"}, {\"name\": \"道具类型\", \"value\": \"近战武器\"}, {\"name\": \"道具品质\", \"value\": \"传说\"}, {\"name\": \"交付方式\", \"value\": \"游戏内手动交付\"}]','[\"gameAccount\", \"serverName\", \"roleName\"]','1','2026-10-22 23:29:54.074',0,'0','2026-10-22 23:29:54.077','2026-10-22 23:29:54.077','admin','admin');
INSERT INTO `mall_prop` (`prop_id`, `category_id`, `name`, `cover_media_id`, `price`, `original_price`, `stock`, `sales`, `detail_html`, `spec_json`, `delivery_fields_json`, `status`, `on_sale_time`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (2,2,'曜金猎弓',5,99.00,159.00,40,0,'<h2>曜金猎弓</h2>\n<p>曜金弓臂搭配琥珀能量弦，黑金结构兼顾锋利线条与华丽纹饰。适合永恒之境中的远程角色。</p>\n<p><img src=\"/api/mall/media/440b9b64fc7a4d0e97a8ec278b034da4.png\" alt=\"曜金猎弓\"></p>\n<h3>交付说明</h3>\n<p>请填写游戏账号、区服和角色名称。支付后由管理员手动交付，请核对资料后下单。</p>\n<p>本商品为原创虚构游戏道具，用于商城演示。请勿填写游戏密码。</p>','[{\"name\": \"所属游戏\", \"value\": \"永恒之境\"}, {\"name\": \"道具类型\", \"value\": \"远程武器\"}, {\"name\": \"道具品质\", \"value\": \"史诗\"}, {\"name\": \"交付方式\", \"value\": \"游戏内手动交付\"}]','[\"gameAccount\", \"serverName\", \"roleName\"]','1','2026-10-22 23:29:54.109',0,'0','2026-10-22 23:29:54.109','2026-10-22 23:29:54.109','admin','admin');
INSERT INTO `mall_prop` (`prop_id`, `category_id`, `name`, `cover_media_id`, `price`, `original_price`, `stock`, `sales`, `detail_html`, `spec_json`, `delivery_fields_json`, `status`, `on_sale_time`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (3,2,'星蝶护符',1,69.90,99.00,60,0,'<h2>星蝶护符</h2>\n<p>以蝶翼与星月为灵感的紫晶护符，细致的银色镶边包裹流光宝石，为角色增添星空主题的装饰效果。</p>\n<p><img src=\"/api/mall/media/81760a5128d34ca3bf6cba8b8205a8db.png\" alt=\"星蝶护符\"></p>\n<h3>交付说明</h3>\n<p>请填写游戏账号、区服和角色名称。支付后由管理员手动交付，请核对资料后下单。</p>\n<p>本商品为原创虚构游戏道具，用于商城演示。请勿填写游戏密码。</p>','[{\"name\": \"所属游戏\", \"value\": \"永恒之境\"}, {\"name\": \"道具类型\", \"value\": \"角色饰品\"}, {\"name\": \"道具品质\", \"value\": \"史诗\"}, {\"name\": \"交付方式\", \"value\": \"游戏内手动交付\"}]','[\"gameAccount\", \"serverName\", \"roleName\"]','1','2026-10-22 23:29:54.129',0,'0','2026-10-22 23:29:54.130','2026-10-22 23:29:54.130','admin','admin');
INSERT INTO `mall_prop` (`prop_id`, `category_id`, `name`, `cover_media_id`, `price`, `original_price`, `stock`, `sales`, `detail_html`, `spec_json`, `delivery_fields_json`, `status`, `on_sale_time`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (4,1,'寒霜结晶',2,19.90,29.90,200,0,'<h2>寒霜结晶</h2>\n<p>凝聚寒霜能量的蓝色晶簇，环绕银色符文圆环。用于星海远征中的装备强化展示，每件按一份材料交付。</p>\n<p><img src=\"/api/mall/media/a05a1d3d258c4c49ae389121e301f995.png\" alt=\"寒霜结晶\"></p>\n<h3>交付说明</h3>\n<p>请填写游戏账号、区服和角色名称。支付后由管理员手动交付，请核对资料后下单。</p>\n<p>本商品为原创虚构游戏道具，用于商城演示。请勿填写游戏密码。</p>','[{\"name\": \"所属游戏\", \"value\": \"星海远征\"}, {\"name\": \"道具类型\", \"value\": \"强化材料\"}, {\"name\": \"道具品质\", \"value\": \"稀有\"}, {\"name\": \"交付方式\", \"value\": \"游戏内手动交付\"}]','[\"gameAccount\", \"serverName\", \"roleName\"]','1','2026-10-22 23:29:54.150',0,'0','2026-10-22 23:29:54.150','2026-10-22 23:29:54.150','admin','admin');
INSERT INTO `mall_prop` (`prop_id`, `category_id`, `name`, `cover_media_id`, `price`, `original_price`, `stock`, `sales`, `detail_html`, `spec_json`, `delivery_fields_json`, `status`, `on_sale_time`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (5,2,'远征补给宝箱',6,29.90,49.00,100,0,'<h2>远征补给宝箱</h2>\n<p>复古黄铜箱体搭配日轮徽记与金色光效。此商品交付一件固定补给宝箱道具，不包含抽奖或随机付费奖励。</p>\n<p><img src=\"/api/mall/media/38698866f5824cce9275ea5ea2bff919.png\" alt=\"远征补给宝箱\"></p>\n<h3>交付说明</h3>\n<p>请填写游戏账号、区服和角色名称。支付后由管理员手动交付，请核对资料后下单。</p>\n<p>本商品为原创虚构游戏道具，用于商城演示。请勿填写游戏密码。</p>','[{\"name\": \"所属游戏\", \"value\": \"永恒之境\"}, {\"name\": \"道具类型\", \"value\": \"补给道具\"}, {\"name\": \"道具品质\", \"value\": \"稀有\"}, {\"name\": \"交付方式\", \"value\": \"游戏内手动交付\"}]','[\"gameAccount\", \"serverName\", \"roleName\"]','1','2026-10-22 23:29:54.168',0,'0','2026-10-22 23:29:54.168','2026-10-22 23:29:54.168','admin','admin');
INSERT INTO `mall_prop` (`prop_id`, `category_id`, `name`, `cover_media_id`, `price`, `original_price`, `stock`, `sales`, `detail_html`, `spec_json`, `delivery_fields_json`, `status`, `on_sale_time`, `version`, `del_flag`, `create_time`, `update_time`, `create_by`, `update_by`) VALUES (6,3,'先驱战术头盔',7,159.00,229.00,18,0,'<h2>先驱战术头盔</h2>\n<p>红黑装甲与发光面罩组成的未来战术头盔，细致呈现机械关节、护甲拼接和能量灯带，适合机甲前线主题角色。</p>\n<p><img src=\"/api/mall/media/3229fecbb9da46da8a2879472e536fea.png\" alt=\"先驱战术头盔\"></p>\n<h3>交付说明</h3>\n<p>请填写游戏账号、区服和角色名称。支付后由管理员手动交付，请核对资料后下单。</p>\n<p>本商品为原创虚构游戏道具，用于商城演示。请勿填写游戏密码。</p>','[{\"name\": \"所属游戏\", \"value\": \"机甲前线\"}, {\"name\": \"道具类型\", \"value\": \"角色装备\"}, {\"name\": \"道具品质\", \"value\": \"传说\"}, {\"name\": \"交付方式\", \"value\": \"游戏内手动交付\"}]','[\"gameAccount\", \"serverName\", \"roleName\"]','1','2026-10-22 23:29:54.186',2,'0','2026-10-22 23:29:54.187','2026-10-23 01:15:00.021','admin','admin');
/*!40000 ALTER TABLE `mall_prop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_prop_image`
--

DROP TABLE IF EXISTS `mall_prop_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_prop_image` (
  `image_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `prop_id` bigint NOT NULL COMMENT '所属商品',
  `media_id` bigint NOT NULL COMMENT '图片媒体',
  `sort` int NOT NULL DEFAULT '0' COMMENT '0–9999，同排序时 image_id 升序',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '关联创建时间',
  PRIMARY KEY (`image_id`),
  UNIQUE KEY `uk_prop_image_media` (`prop_id`,`media_id`),
  KEY `idx_prop_image_sort` (`prop_id`,`sort`,`image_id`),
  KEY `fk_prop_image_media` (`media_id`),
  CONSTRAINT `fk_prop_image_media` FOREIGN KEY (`media_id`) REFERENCES `mall_media` (`media_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_prop_image_prop` FOREIGN KEY (`prop_id`) REFERENCES `mall_prop` (`prop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_prop_image_sort` CHECK ((`sort` between 0 and 9999))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品多图关联';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_prop_image`
--
-- ORDER BY:  `image_id`,`prop_id`,`media_id`,`prop_id`,`sort`,`image_id`,`media_id`

LOCK TABLES `mall_prop_image` WRITE;
/*!40000 ALTER TABLE `mall_prop_image` DISABLE KEYS */;
INSERT INTO `mall_prop_image` (`image_id`, `prop_id`, `media_id`, `sort`, `create_time`) VALUES (1,1,3,0,'2026-10-22 23:29:54.080');
INSERT INTO `mall_prop_image` (`image_id`, `prop_id`, `media_id`, `sort`, `create_time`) VALUES (2,2,5,0,'2026-10-22 23:29:54.112');
INSERT INTO `mall_prop_image` (`image_id`, `prop_id`, `media_id`, `sort`, `create_time`) VALUES (3,3,1,0,'2026-10-22 23:29:54.133');
INSERT INTO `mall_prop_image` (`image_id`, `prop_id`, `media_id`, `sort`, `create_time`) VALUES (4,4,2,0,'2026-10-22 23:29:54.152');
INSERT INTO `mall_prop_image` (`image_id`, `prop_id`, `media_id`, `sort`, `create_time`) VALUES (5,5,6,0,'2026-10-22 23:29:54.170');
INSERT INTO `mall_prop_image` (`image_id`, `prop_id`, `media_id`, `sort`, `create_time`) VALUES (6,6,7,0,'2026-10-22 23:29:54.189');
/*!40000 ALTER TABLE `mall_prop_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_review`
--

DROP TABLE IF EXISTS `mall_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_review` (
  `review_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `member_id` bigint NOT NULL COMMENT '评价会员，与订单归属组成复合外键',
  `order_id` bigint NOT NULL COMMENT '订单关联',
  `order_item_id` bigint NOT NULL COMMENT '唯一被评价明细，隐藏也不释放唯一约束',
  `prop_id` bigint NOT NULL COMMENT '商品关联，与明细组合外键保证一致',
  `score` tinyint NOT NULL COMMENT '1–5 整数评分',
  `content` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '5–1000 字符纯文本，不解析 HTML',
  `status` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VISIBLE' COMMENT 'VISIBLE 或 HIDDEN',
  `hide_reason` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '隐藏原因，隐藏时必填',
  `hidden_by` bigint DEFAULT NULL COMMENT '隐藏操作者后台 ID，逻辑关联 sys_user',
  `hidden_time` datetime(3) DEFAULT NULL COMMENT '隐藏时间',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  PRIMARY KEY (`review_id`),
  UNIQUE KEY `uk_review_order_item` (`order_item_id`),
  KEY `idx_review_public` (`prop_id`,`status`,`create_time` DESC,`review_id` DESC),
  KEY `idx_review_member` (`member_id`,`create_time` DESC,`review_id` DESC),
  KEY `fk_review_owner` (`order_id`,`member_id`),
  KEY `fk_review_item` (`order_item_id`,`order_id`,`prop_id`),
  CONSTRAINT `fk_review_item` FOREIGN KEY (`order_item_id`, `order_id`, `prop_id`) REFERENCES `mall_order_item` (`order_item_id`, `order_id`, `prop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_review_owner` FOREIGN KEY (`order_id`, `member_id`) REFERENCES `mall_order` (`order_id`, `member_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_review_content` CHECK (((`score` between 1 and 5) and (char_length(`content`) between 5 and 1000))),
  CONSTRAINT `ck_review_visibility` CHECK ((((`status` = _utf8mb4'VISIBLE') and (`hide_reason` is null) and (`hidden_by` is null) and (`hidden_time` is null)) or ((`status` = _utf8mb4'HIDDEN') and (`hide_reason` is not null) and (char_length(`hide_reason`) between 2 and 200) and (`hidden_by` is not null) and (`hidden_by` > 0) and (`hidden_time` is not null))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='每条已完成订单明细唯一评价';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_review`
--
-- ORDER BY:  `review_id`,`order_item_id`,`prop_id`,`status`,`create_time`,`review_id`,`member_id`,`create_time`,`review_id`,`order_id`,`member_id`,`order_item_id`,`order_id`,`prop_id`

LOCK TABLES `mall_review` WRITE;
/*!40000 ALTER TABLE `mall_review` DISABLE KEYS */;
/*!40000 ALTER TABLE `mall_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_schema_history`
--

DROP TABLE IF EXISTS `mall_schema_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_schema_history` (
  `version` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '已经完整执行的迁移版本，例如 V001',
  `script_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '不可改写的脚本文件名',
  `description` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '迁移说明',
  `installed_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '该脚本全部语句完成的记录时间',
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商城增量脚本版本记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_schema_history`
--
-- ORDER BY:  `version`

LOCK TABLES `mall_schema_history` WRITE;
/*!40000 ALTER TABLE `mall_schema_history` DISABLE KEYS */;
INSERT INTO `mall_schema_history` (`version`, `script_name`, `description`, `installed_time`) VALUES ('V001','V001__create_mall_tables.sql','创建 14 张商城业务表及迁移版本表','2026-10-22 22:13:57.189');
INSERT INTO `mall_schema_history` (`version`, `script_name`, `description`, `installed_time`) VALUES ('V002','V002__register_order_expiry_job.sql','注册每分钟的 Quartz 商城超时关单任务','2026-10-22 22:13:57.196');
INSERT INTO `mall_schema_history` (`version`, `script_name`, `description`, `installed_time`) VALUES ('V003','V003__register_admin_menus.sql','注册七个商城后台页面、路由和按钮权限','2026-10-22 22:13:57.206');
INSERT INTO `mall_schema_history` (`version`, `script_name`, `description`, `installed_time`) VALUES ('V004','V004__customize_admin_brand.sql','替换商城后台默认展示、组织和公告，移除官网宣传菜单','2026-10-22 22:49:26.014');
INSERT INTO `mall_schema_history` (`version`, `script_name`, `description`, `installed_time`) VALUES ('V005','V005__prune_admin_menus.sql','移除部门岗位、系统监控和系统工具的菜单、后代与角色关联','2026-10-22 23:09:34.776');
INSERT INTO `mall_schema_history` (`version`, `script_name`, `description`, `installed_time`) VALUES ('V006','V006__game_servers.sql','游戏区服、分类关联、默认区服与后台页面及按钮权限','2026-10-23 00:17:43.889');
INSERT INTO `mall_schema_history` (`version`, `script_name`, `description`, `installed_time`) VALUES ('V007','V007__ruoyi_storefront_identity.sql','商城统一若依认证、普通用户角色与历史账号迁移','2026-10-23 01:11:37.060');
/*!40000 ALTER TABLE `mall_schema_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_stock_log`
--

DROP TABLE IF EXISTS `mall_stock_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_stock_log` (
  `stock_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `prop_id` bigint NOT NULL COMMENT '商品关联',
  `prop_name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '库存变动时商品名称快照',
  `change_qty` int NOT NULL COMMENT '本次增减量，初始库存允许 0，库存调整不允许 0',
  `before_stock` int NOT NULL COMMENT '变更前库存，必须在锁/原子更新事务中取得',
  `after_stock` int NOT NULL COMMENT '变更后库存，必须等于 before_stock+change_qty',
  `biz_type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'INITIAL/ORDER_RESERVE/ORDER_RELEASE/ADMIN_ADJUST',
  `biz_key` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT 'INITIAL=商品 ID；订单类=orderNo；调整=requestKey',
  `request_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL COMMENT 'ADMIN_ADJUST 时必填，摘要包含 propId/operatorId/delta/reason；其他类型可空',
  `order_id` bigint DEFAULT NULL COMMENT '订单扣减/回补时必填，初始和人工调整为 null',
  `operator_type` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ADMIN、MEMBER、SYSTEM，多态操作者类型',
  `operator_id` bigint DEFAULT NULL COMMENT '按类型逻辑关联 sys_user 或 mall_member；SYSTEM 必须 null',
  `operator_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '账号快照；SYSTEM 使用 system',
  `reason` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '库存变动或人工调整原因',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '变动时间',
  PRIMARY KEY (`stock_log_id`),
  UNIQUE KEY `uk_stock_biz` (`prop_id`,`biz_type`,`biz_key`),
  KEY `idx_stock_prop_time` (`prop_id`,`create_time` DESC,`stock_log_id` DESC),
  KEY `idx_stock_type_time` (`biz_type`,`create_time` DESC,`stock_log_id` DESC),
  KEY `fk_stock_order` (`order_id`),
  CONSTRAINT `fk_stock_order` FOREIGN KEY (`order_id`) REFERENCES `mall_order` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_stock_prop` FOREIGN KEY (`prop_id`) REFERENCES `mall_prop` (`prop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_stock_arithmetic` CHECK (((`before_stock` between 0 and 1000000000) and (`after_stock` between 0 and 1000000000) and (`change_qty` between -(1000000000) and 1000000000) and (`after_stock` = (`before_stock` + `change_qty`)))),
  CONSTRAINT `ck_stock_biz` CHECK ((((`biz_type` = _utf8mb4'INITIAL') and (`before_stock` = 0) and (`change_qty` >= 0) and (`order_id` is null)) or ((`biz_type` = _utf8mb4'ORDER_RESERVE') and (`change_qty` < 0) and (`order_id` is not null)) or ((`biz_type` = _utf8mb4'ORDER_RELEASE') and (`change_qty` > 0) and (`order_id` is not null)) or ((`biz_type` = _utf8mb4'ADMIN_ADJUST') and (`change_qty` <> 0) and (`order_id` is null) and (`request_hash` is not null)))),
  CONSTRAINT `ck_stock_operator` CHECK ((((`operator_type` = _utf8mb4'SYSTEM') and (`operator_id` is null)) or ((`operator_type` in (_utf8mb4'ADMIN',_utf8mb4'MEMBER')) and (`operator_id` is not null) and (`operator_id` > 0))))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='只追加库存流水及库存调整幂等凭据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_stock_log`
--
-- ORDER BY:  `stock_log_id`,`prop_id`,`biz_type`,`biz_key`,`prop_id`,`create_time`,`stock_log_id`,`biz_type`,`create_time`,`stock_log_id`,`order_id`

LOCK TABLES `mall_stock_log` WRITE;
/*!40000 ALTER TABLE `mall_stock_log` DISABLE KEYS */;
INSERT INTO `mall_stock_log` (`stock_log_id`, `prop_id`, `prop_name`, `change_qty`, `before_stock`, `after_stock`, `biz_type`, `biz_key`, `request_hash`, `order_id`, `operator_type`, `operator_id`, `operator_name`, `reason`, `create_time`) VALUES (1,1,'星辉长剑·青曜',25,0,25,'INITIAL','1',NULL,NULL,'ADMIN',1,'admin','创建商品初始库存','2026-10-22 23:29:54.081');
INSERT INTO `mall_stock_log` (`stock_log_id`, `prop_id`, `prop_name`, `change_qty`, `before_stock`, `after_stock`, `biz_type`, `biz_key`, `request_hash`, `order_id`, `operator_type`, `operator_id`, `operator_name`, `reason`, `create_time`) VALUES (2,2,'曜金猎弓',40,0,40,'INITIAL','2',NULL,NULL,'ADMIN',1,'admin','创建商品初始库存','2026-10-22 23:29:54.113');
INSERT INTO `mall_stock_log` (`stock_log_id`, `prop_id`, `prop_name`, `change_qty`, `before_stock`, `after_stock`, `biz_type`, `biz_key`, `request_hash`, `order_id`, `operator_type`, `operator_id`, `operator_name`, `reason`, `create_time`) VALUES (3,3,'星蝶护符',60,0,60,'INITIAL','3',NULL,NULL,'ADMIN',1,'admin','创建商品初始库存','2026-10-22 23:29:54.134');
INSERT INTO `mall_stock_log` (`stock_log_id`, `prop_id`, `prop_name`, `change_qty`, `before_stock`, `after_stock`, `biz_type`, `biz_key`, `request_hash`, `order_id`, `operator_type`, `operator_id`, `operator_name`, `reason`, `create_time`) VALUES (4,4,'寒霜结晶',200,0,200,'INITIAL','4',NULL,NULL,'ADMIN',1,'admin','创建商品初始库存','2026-10-22 23:29:54.153');
INSERT INTO `mall_stock_log` (`stock_log_id`, `prop_id`, `prop_name`, `change_qty`, `before_stock`, `after_stock`, `biz_type`, `biz_key`, `request_hash`, `order_id`, `operator_type`, `operator_id`, `operator_name`, `reason`, `create_time`) VALUES (5,5,'远征补给宝箱',100,0,100,'INITIAL','5',NULL,NULL,'ADMIN',1,'admin','创建商品初始库存','2026-10-22 23:29:54.170');
INSERT INTO `mall_stock_log` (`stock_log_id`, `prop_id`, `prop_name`, `change_qty`, `before_stock`, `after_stock`, `biz_type`, `biz_key`, `request_hash`, `order_id`, `operator_type`, `operator_id`, `operator_name`, `reason`, `create_time`) VALUES (6,6,'先驱战术头盔',18,0,18,'INITIAL','6',NULL,NULL,'ADMIN',1,'admin','创建商品初始库存','2026-10-22 23:29:54.190');
INSERT INTO `mall_stock_log` (`stock_log_id`, `prop_id`, `prop_name`, `change_qty`, `before_stock`, `after_stock`, `biz_type`, `biz_key`, `request_hash`, `order_id`, `operator_type`, `operator_id`, `operator_name`, `reason`, `create_time`) VALUES (7,6,'先驱战术头盔',-1,18,17,'ORDER_RESERVE','GC20261023004452833CC433AE96A71',NULL,1,'MEMBER',1,'mfenggg','下单预留库存','2026-10-23 00:44:52.844');
INSERT INTO `mall_stock_log` (`stock_log_id`, `prop_id`, `prop_name`, `change_qty`, `before_stock`, `after_stock`, `biz_type`, `biz_key`, `request_hash`, `order_id`, `operator_type`, `operator_id`, `operator_name`, `reason`, `create_time`) VALUES (8,6,'先驱战术头盔',1,17,18,'ORDER_RELEASE','GC20261023004452833CC433AE96A71',NULL,1,'SYSTEM',NULL,'system','超时未支付自动关闭','2026-10-23 01:15:00.024');
/*!40000 ALTER TABLE `mall_stock_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Blob类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_blob_triggers`
--
-- ORDER BY:  `sched_name`,`trigger_name`,`trigger_group`

LOCK TABLES `qrtz_blob_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_blob_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_blob_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_calendars`
--

DROP TABLE IF EXISTS `qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='日历信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_calendars`
--
-- ORDER BY:  `sched_name`,`calendar_name`

LOCK TABLES `qrtz_calendars` WRITE;
/*!40000 ALTER TABLE `qrtz_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cron类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_cron_triggers`
--
-- ORDER BY:  `sched_name`,`trigger_name`,`trigger_group`

LOCK TABLES `qrtz_cron_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_cron_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_cron_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='已触发的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_fired_triggers`
--
-- ORDER BY:  `sched_name`,`entry_id`

LOCK TABLES `qrtz_fired_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_fired_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_fired_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_job_details`
--
-- ORDER BY:  `sched_name`,`job_name`,`job_group`

LOCK TABLES `qrtz_job_details` WRITE;
/*!40000 ALTER TABLE `qrtz_job_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_job_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='存储的悲观锁信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_locks`
--
-- ORDER BY:  `sched_name`,`lock_name`

LOCK TABLES `qrtz_locks` WRITE;
/*!40000 ALTER TABLE `qrtz_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='暂停的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_paused_trigger_grps`
--
-- ORDER BY:  `sched_name`,`trigger_group`

LOCK TABLES `qrtz_paused_trigger_grps` WRITE;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='调度器状态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_scheduler_state`
--
-- ORDER BY:  `sched_name`,`instance_name`

LOCK TABLES `qrtz_scheduler_state` WRITE;
/*!40000 ALTER TABLE `qrtz_scheduler_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_scheduler_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='简单触发器的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simple_triggers`
--
-- ORDER BY:  `sched_name`,`trigger_name`,`trigger_group`

LOCK TABLES `qrtz_simple_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simple_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simple_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='同步机制的行锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simprop_triggers`
--
-- ORDER BY:  `sched_name`,`trigger_name`,`trigger_group`

LOCK TABLES `qrtz_simprop_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`),
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='触发器详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_triggers`
--
-- ORDER BY:  `sched_name`,`trigger_name`,`trigger_group`,`sched_name`,`job_name`,`job_group`

LOCK TABLES `qrtz_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--
-- ORDER BY:  `config_id`

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2026-10-22 18:55:55','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2026-10-22 18:55:55','',NULL,'初始化密码 123456');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2026-10-22 18:55:55','',NULL,'深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2026-10-22 18:55:55','',NULL,'是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5,'账号自助-是否开启用户注册功能','sys.account.registerUser','true','Y','admin','2026-10-22 18:55:55','migration','2026-10-23 01:11:36','是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2026-10-22 18:55:55','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (7,'用户管理-初始密码修改策略','sys.account.initPasswordModify','1','Y','admin','2026-10-22 18:55:55','',NULL,'0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8,'用户管理-账号密码更新周期','sys.account.passwordValidateDays','0','Y','admin','2026-10-22 18:55:55','',NULL,'密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9,'用户管理-密码字符范围','sys.account.chrtype','0','Y','admin','2026-10-22 18:55:55','',NULL,'默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--
-- ORDER BY:  `dept_id`

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (100,0,'0','商城运营中心',0,'商城管理员','15888888888',NULL,'0','0','admin','2026-10-22 18:55:55','migration','2026-10-22 22:49:26');
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (101,100,'0,100','商品运营组',1,'商城管理员','15888888888',NULL,'0','0','admin','2026-10-22 18:55:55','migration','2026-10-22 22:49:26');
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (102,100,'0,100','订单服务组',2,'商城管理员','15888888888',NULL,'0','0','admin','2026-10-22 18:55:55','migration','2026-10-22 22:49:26');
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (103,101,'0,100,101','研发部门',1,'商城管理员','15888888888',NULL,'0','0','admin','2026-10-22 18:55:55','migration','2026-10-22 22:49:26');
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (104,101,'0,100,101','市场部门',2,'商城管理员','15888888888',NULL,'0','0','admin','2026-10-22 18:55:55','migration','2026-10-22 22:49:26');
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (105,101,'0,100,101','测试部门',3,'商城管理员','15888888888',NULL,'0','0','admin','2026-10-22 18:55:55','migration','2026-10-22 22:49:26');
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (106,101,'0,100,101','财务部门',4,'商城管理员','15888888888',NULL,'0','0','admin','2026-10-22 18:55:55','migration','2026-10-22 22:49:26');
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (107,101,'0,100,101','运维部门',5,'商城管理员','15888888888',NULL,'0','0','admin','2026-10-22 18:55:55','migration','2026-10-22 22:49:26');
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (108,102,'0,100,102','市场部门',1,'商城管理员','15888888888',NULL,'0','0','admin','2026-10-22 18:55:55','migration','2026-10-22 22:49:26');
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (109,102,'0,100,102','财务部门',2,'商城管理员','15888888888',NULL,'0','0','admin','2026-10-22 18:55:55','migration','2026-10-22 22:49:26');
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) COLLATE utf8mb4_unicode_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--
-- ORDER BY:  `dict_code`

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2026-10-22 18:55:55','',NULL,'性别男');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,2,'女','1','sys_user_sex','','','N','0','admin','2026-10-22 18:55:55','',NULL,'性别女');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,3,'未知','2','sys_user_sex','','','N','0','admin','2026-10-22 18:55:55','',NULL,'性别未知');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2026-10-22 18:55:55','',NULL,'显示菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2026-10-22 18:55:55','',NULL,'隐藏菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2026-10-22 18:55:55','',NULL,'正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2026-10-22 18:55:55','',NULL,'停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2026-10-22 18:55:55','',NULL,'正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2026-10-22 18:55:55','',NULL,'停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2026-10-22 18:55:55','',NULL,'默认分组');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2026-10-22 18:55:55','',NULL,'系统分组');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2026-10-22 18:55:55','',NULL,'系统默认是');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (13,2,'否','N','sys_yes_no','','danger','N','0','admin','2026-10-22 18:55:55','',NULL,'系统默认否');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2026-10-22 18:55:55','',NULL,'通知');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (15,2,'公告','2','sys_notice_type','','success','N','0','admin','2026-10-22 18:55:55','',NULL,'公告');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2026-10-22 18:55:55','',NULL,'正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2026-10-22 18:55:55','',NULL,'关闭状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (18,99,'其他','0','sys_oper_type','','info','N','0','admin','2026-10-22 18:55:55','',NULL,'其他操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (19,1,'新增','1','sys_oper_type','','info','N','0','admin','2026-10-22 18:55:55','',NULL,'新增操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (20,2,'修改','2','sys_oper_type','','info','N','0','admin','2026-10-22 18:55:55','',NULL,'修改操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2026-10-22 18:55:55','',NULL,'删除操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2026-10-22 18:55:55','',NULL,'授权操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2026-10-22 18:55:55','',NULL,'导出操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2026-10-22 18:55:55','',NULL,'导入操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2026-10-22 18:55:55','',NULL,'强退操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2026-10-22 18:55:55','',NULL,'生成操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2026-10-22 18:55:55','',NULL,'清空操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (28,1,'成功','0','sys_common_status','','primary','N','0','admin','2026-10-22 18:55:55','',NULL,'正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (29,2,'失败','1','sys_common_status','','danger','N','0','admin','2026-10-22 18:55:55','',NULL,'停用状态');
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--
-- ORDER BY:  `dict_id`,`dict_type`

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'用户性别','sys_user_sex','0','admin','2026-10-22 18:55:55','',NULL,'用户性别列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'菜单状态','sys_show_hide','0','admin','2026-10-22 18:55:55','',NULL,'菜单状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'系统开关','sys_normal_disable','0','admin','2026-10-22 18:55:55','',NULL,'系统开关列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,'任务状态','sys_job_status','0','admin','2026-10-22 18:55:55','',NULL,'任务状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5,'任务分组','sys_job_group','0','admin','2026-10-22 18:55:55','',NULL,'任务分组列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6,'系统是否','sys_yes_no','0','admin','2026-10-22 18:55:55','',NULL,'系统是否列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (7,'通知类型','sys_notice_type','0','admin','2026-10-22 18:55:55','',NULL,'通知类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8,'通知状态','sys_notice_status','0','admin','2026-10-22 18:55:55','',NULL,'通知状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9,'操作类型','sys_oper_type','0','admin','2026-10-22 18:55:55','',NULL,'操作类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (10,'系统状态','sys_common_status','0','admin','2026-10-22 18:55:55','',NULL,'登录状态列表');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--
-- ORDER BY:  `job_id`,`job_name`,`job_group`

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (100,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','0 * * * * ?','2','1','0','migration','2026-10-22 22:13:57','',NULL,'复用订单取消服务，逐单事务，状态竞争与库存回补幂等');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '异常信息',
  `start_time` datetime DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=192 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--
-- ORDER BY:  `job_log_id`

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (1,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：17毫秒','0','','2026-10-22 22:26:00','2026-10-22 22:26:00','2026-10-22 22:26:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (2,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-22 22:27:00','2026-10-22 22:27:00','2026-10-22 22:27:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (3,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：16毫秒','0','','2026-10-22 22:28:00','2026-10-22 22:28:00','2026-10-22 22:28:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (4,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-22 22:29:00','2026-10-22 22:29:00','2026-10-22 22:29:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (5,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：9毫秒','0','','2026-10-22 22:30:00','2026-10-22 22:30:00','2026-10-22 22:30:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (6,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-22 22:31:00','2026-10-22 22:31:00','2026-10-22 22:31:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (7,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：5毫秒','0','','2026-10-22 22:32:00','2026-10-22 22:32:00','2026-10-22 22:32:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (8,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：5毫秒','0','','2026-10-22 22:33:00','2026-10-22 22:33:00','2026-10-22 22:33:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (9,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-22 22:34:00','2026-10-22 22:34:00','2026-10-22 22:34:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (10,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 22:35:00','2026-10-22 22:35:00','2026-10-22 22:35:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (11,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：15毫秒','0','','2026-10-22 22:36:00','2026-10-22 22:36:00','2026-10-22 22:36:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (12,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：5毫秒','0','','2026-10-22 22:37:00','2026-10-22 22:37:00','2026-10-22 22:37:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (13,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：7毫秒','0','','2026-10-22 22:38:00','2026-10-22 22:38:00','2026-10-22 22:38:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (14,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：18毫秒','0','','2026-10-22 22:39:00','2026-10-22 22:39:00','2026-10-22 22:39:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (15,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：4毫秒','0','','2026-10-22 22:40:00','2026-10-22 22:40:00','2026-10-22 22:40:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (16,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：40毫秒','0','','2026-10-22 22:41:00','2026-10-22 22:41:00','2026-10-22 22:41:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (17,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-22 22:42:00','2026-10-22 22:42:00','2026-10-22 22:42:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (18,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：106毫秒','0','','2026-10-22 22:43:00','2026-10-22 22:43:00','2026-10-22 22:43:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (19,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：23毫秒','0','','2026-10-22 22:44:00','2026-10-22 22:44:00','2026-10-22 22:44:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (20,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：14毫秒','0','','2026-10-22 22:45:00','2026-10-22 22:45:00','2026-10-22 22:45:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (21,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 22:46:00','2026-10-22 22:46:00','2026-10-22 22:46:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (22,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 22:47:00','2026-10-22 22:47:00','2026-10-22 22:47:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (23,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：4毫秒','0','','2026-10-22 22:48:00','2026-10-22 22:48:00','2026-10-22 22:48:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (24,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 22:49:00','2026-10-22 22:49:00','2026-10-22 22:49:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (25,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 22:50:00','2026-10-22 22:50:00','2026-10-22 22:50:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (26,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 22:51:00','2026-10-22 22:51:00','2026-10-22 22:51:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (27,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 22:52:00','2026-10-22 22:52:00','2026-10-22 22:52:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (28,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 22:53:00','2026-10-22 22:53:00','2026-10-22 22:53:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (29,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-22 22:54:00','2026-10-22 22:54:00','2026-10-22 22:54:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (30,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 22:55:00','2026-10-22 22:55:00','2026-10-22 22:55:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (31,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 22:56:00','2026-10-22 22:56:00','2026-10-22 22:56:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (32,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-22 22:57:00','2026-10-22 22:57:00','2026-10-22 22:57:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (33,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 22:58:00','2026-10-22 22:58:00','2026-10-22 22:58:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (34,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 22:59:00','2026-10-22 22:59:00','2026-10-22 22:59:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (35,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:00:00','2026-10-22 23:00:00','2026-10-22 23:00:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (36,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:01:00','2026-10-22 23:01:00','2026-10-22 23:01:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (37,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:02:00','2026-10-22 23:02:00','2026-10-22 23:02:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (38,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:03:00','2026-10-22 23:03:00','2026-10-22 23:03:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (39,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:04:00','2026-10-22 23:04:00','2026-10-22 23:04:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (40,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:05:00','2026-10-22 23:05:00','2026-10-22 23:05:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (41,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:06:00','2026-10-22 23:06:00','2026-10-22 23:06:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (42,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:07:00','2026-10-22 23:07:00','2026-10-22 23:07:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (43,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:08:00','2026-10-22 23:08:00','2026-10-22 23:08:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (44,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：4毫秒','0','','2026-10-22 23:09:00','2026-10-22 23:09:00','2026-10-22 23:09:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (45,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:10:00','2026-10-22 23:10:00','2026-10-22 23:10:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (46,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:11:00','2026-10-22 23:11:00','2026-10-22 23:11:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (47,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:12:00','2026-10-22 23:12:00','2026-10-22 23:12:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (48,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:13:00','2026-10-22 23:13:00','2026-10-22 23:13:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (49,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:14:00','2026-10-22 23:14:00','2026-10-22 23:14:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (50,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:15:00','2026-10-22 23:15:00','2026-10-22 23:15:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (51,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:16:00','2026-10-22 23:16:00','2026-10-22 23:16:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (52,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:17:00','2026-10-22 23:17:00','2026-10-22 23:17:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (53,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:18:00','2026-10-22 23:18:00','2026-10-22 23:18:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (54,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:19:00','2026-10-22 23:19:00','2026-10-22 23:19:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (55,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:20:00','2026-10-22 23:20:00','2026-10-22 23:20:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (56,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:21:00','2026-10-22 23:21:00','2026-10-22 23:21:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (57,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:22:00','2026-10-22 23:22:00','2026-10-22 23:22:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (58,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:23:00','2026-10-22 23:23:00','2026-10-22 23:23:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (59,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:24:00','2026-10-22 23:24:00','2026-10-22 23:24:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (60,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:25:00','2026-10-22 23:25:00','2026-10-22 23:25:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (61,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:26:00','2026-10-22 23:26:00','2026-10-22 23:26:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (62,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:27:00','2026-10-22 23:27:00','2026-10-22 23:27:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (63,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:28:00','2026-10-22 23:28:00','2026-10-22 23:28:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (64,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:29:00','2026-10-22 23:29:00','2026-10-22 23:29:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (65,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:30:00','2026-10-22 23:30:00','2026-10-22 23:30:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (66,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:31:00','2026-10-22 23:31:00','2026-10-22 23:31:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (67,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:32:00','2026-10-22 23:32:00','2026-10-22 23:32:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (68,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:33:00','2026-10-22 23:33:00','2026-10-22 23:33:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (69,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:34:00','2026-10-22 23:34:00','2026-10-22 23:34:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (70,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:35:00','2026-10-22 23:35:00','2026-10-22 23:35:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (71,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:36:00','2026-10-22 23:36:00','2026-10-22 23:36:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (72,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:37:00','2026-10-22 23:37:00','2026-10-22 23:37:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (73,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:38:00','2026-10-22 23:38:00','2026-10-22 23:38:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (74,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:39:00','2026-10-22 23:39:00','2026-10-22 23:39:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (75,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：8毫秒','0','','2026-10-22 23:41:00','2026-10-22 23:41:00','2026-10-22 23:41:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (76,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:42:00','2026-10-22 23:42:00','2026-10-22 23:42:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (77,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:43:00','2026-10-22 23:43:00','2026-10-22 23:43:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (78,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:44:00','2026-10-22 23:44:00','2026-10-22 23:44:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (79,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:45:00','2026-10-22 23:45:00','2026-10-22 23:45:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (80,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:46:00','2026-10-22 23:46:00','2026-10-22 23:46:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (81,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-22 23:47:00','2026-10-22 23:47:00','2026-10-22 23:47:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (82,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:48:00','2026-10-22 23:48:00','2026-10-22 23:48:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (83,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-22 23:49:00','2026-10-22 23:49:00','2026-10-22 23:49:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (84,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:50:00','2026-10-22 23:50:00','2026-10-22 23:50:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (85,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:51:00','2026-10-22 23:51:00','2026-10-22 23:51:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (86,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:52:00','2026-10-22 23:52:00','2026-10-22 23:52:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (87,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:53:00','2026-10-22 23:53:00','2026-10-22 23:53:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (88,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:54:00','2026-10-22 23:54:00','2026-10-22 23:54:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (89,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:55:00','2026-10-22 23:55:00','2026-10-22 23:55:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (90,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:56:00','2026-10-22 23:56:00','2026-10-22 23:56:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (91,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:57:00','2026-10-22 23:57:00','2026-10-22 23:57:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (92,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-22 23:58:00','2026-10-22 23:58:00','2026-10-22 23:58:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (93,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-22 23:59:00','2026-10-22 23:59:00','2026-10-22 23:59:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (94,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:00:00','2026-10-23 00:00:00','2026-10-23 00:00:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (95,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:01:00','2026-10-23 00:01:00','2026-10-23 00:01:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (96,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:02:00','2026-10-23 00:02:00','2026-10-23 00:02:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (97,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:03:00','2026-10-23 00:03:00','2026-10-23 00:03:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (98,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:04:00','2026-10-23 00:04:00','2026-10-23 00:04:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (99,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-23 00:05:00','2026-10-23 00:05:00','2026-10-23 00:05:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (100,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:06:00','2026-10-23 00:06:00','2026-10-23 00:06:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (101,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:07:00','2026-10-23 00:07:00','2026-10-23 00:07:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (102,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:08:00','2026-10-23 00:08:00','2026-10-23 00:08:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (103,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:09:00','2026-10-23 00:09:00','2026-10-23 00:09:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (104,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:10:00','2026-10-23 00:10:00','2026-10-23 00:10:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (105,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:11:00','2026-10-23 00:11:00','2026-10-23 00:11:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (106,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:12:00','2026-10-23 00:12:00','2026-10-23 00:12:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (107,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:13:00','2026-10-23 00:13:00','2026-10-23 00:13:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (108,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:14:00','2026-10-23 00:14:00','2026-10-23 00:14:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (109,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:15:00','2026-10-23 00:15:00','2026-10-23 00:15:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (110,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:16:00','2026-10-23 00:16:00','2026-10-23 00:16:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (111,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:17:00','2026-10-23 00:17:00','2026-10-23 00:17:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (112,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：6毫秒','0','','2026-10-23 00:19:00','2026-10-23 00:19:00','2026-10-23 00:19:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (113,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:20:00','2026-10-23 00:20:00','2026-10-23 00:20:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (114,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:21:00','2026-10-23 00:21:00','2026-10-23 00:21:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (115,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:22:00','2026-10-23 00:22:00','2026-10-23 00:22:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (116,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:23:00','2026-10-23 00:23:00','2026-10-23 00:23:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (117,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:24:00','2026-10-23 00:24:00','2026-10-23 00:24:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (118,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：4毫秒','0','','2026-10-23 00:25:00','2026-10-23 00:25:00','2026-10-23 00:25:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (119,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:26:00','2026-10-23 00:26:00','2026-10-23 00:26:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (120,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:27:00','2026-10-23 00:27:00','2026-10-23 00:27:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (121,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：4毫秒','0','','2026-10-23 00:28:00','2026-10-23 00:28:00','2026-10-23 00:28:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (122,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-23 00:29:00','2026-10-23 00:29:00','2026-10-23 00:29:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (123,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:30:00','2026-10-23 00:30:00','2026-10-23 00:30:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (124,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:31:00','2026-10-23 00:31:00','2026-10-23 00:31:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (125,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-23 00:32:00','2026-10-23 00:32:00','2026-10-23 00:32:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (126,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:33:00','2026-10-23 00:33:00','2026-10-23 00:33:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (127,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:34:00','2026-10-23 00:34:00','2026-10-23 00:34:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (128,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:35:00','2026-10-23 00:35:00','2026-10-23 00:35:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (129,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:36:00','2026-10-23 00:36:00','2026-10-23 00:36:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (130,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:37:00','2026-10-23 00:37:00','2026-10-23 00:37:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (131,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:38:00','2026-10-23 00:38:00','2026-10-23 00:38:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (132,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：4毫秒','0','','2026-10-23 00:39:00','2026-10-23 00:39:00','2026-10-23 00:39:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (133,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:40:00','2026-10-23 00:40:00','2026-10-23 00:40:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (134,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:41:00','2026-10-23 00:41:00','2026-10-23 00:41:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (135,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:42:00','2026-10-23 00:42:00','2026-10-23 00:42:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (136,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:43:00','2026-10-23 00:43:00','2026-10-23 00:43:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (137,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:44:00','2026-10-23 00:44:00','2026-10-23 00:44:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (138,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:45:00','2026-10-23 00:45:00','2026-10-23 00:45:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (139,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:46:00','2026-10-23 00:46:00','2026-10-23 00:46:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (140,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:47:00','2026-10-23 00:47:00','2026-10-23 00:47:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (141,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-23 00:48:00','2026-10-23 00:48:00','2026-10-23 00:48:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (142,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:49:00','2026-10-23 00:49:00','2026-10-23 00:49:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (143,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:50:00','2026-10-23 00:50:00','2026-10-23 00:50:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (144,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：5毫秒','0','','2026-10-23 00:51:00','2026-10-23 00:51:00','2026-10-23 00:51:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (145,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:52:00','2026-10-23 00:52:00','2026-10-23 00:52:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (146,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:53:00','2026-10-23 00:53:00','2026-10-23 00:53:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (147,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:54:00','2026-10-23 00:54:00','2026-10-23 00:54:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (148,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:55:00','2026-10-23 00:55:00','2026-10-23 00:55:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (149,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 00:56:00','2026-10-23 00:56:00','2026-10-23 00:56:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (150,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:57:00','2026-10-23 00:57:00','2026-10-23 00:57:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (151,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-23 00:58:00','2026-10-23 00:58:00','2026-10-23 00:58:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (152,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 00:59:00','2026-10-23 00:59:00','2026-10-23 00:59:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (153,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 01:00:00','2026-10-23 01:00:00','2026-10-23 01:00:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (154,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:01:00','2026-10-23 01:01:00','2026-10-23 01:01:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (155,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 01:02:00','2026-10-23 01:02:00','2026-10-23 01:02:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (156,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:03:00','2026-10-23 01:03:00','2026-10-23 01:03:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (157,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 01:04:00','2026-10-23 01:04:00','2026-10-23 01:04:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (158,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 01:05:00','2026-10-23 01:05:00','2026-10-23 01:05:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (159,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:06:00','2026-10-23 01:06:00','2026-10-23 01:06:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (160,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 01:07:00','2026-10-23 01:07:00','2026-10-23 01:07:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (161,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:08:00','2026-10-23 01:08:00','2026-10-23 01:08:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (162,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 01:09:00','2026-10-23 01:09:00','2026-10-23 01:09:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (163,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 01:10:00','2026-10-23 01:10:00','2026-10-23 01:10:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (164,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:11:00','2026-10-23 01:11:00','2026-10-23 01:11:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (165,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：4毫秒','0','','2026-10-23 01:13:00','2026-10-23 01:13:00','2026-10-23 01:13:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (166,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:14:00','2026-10-23 01:14:00','2026-10-23 01:14:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (167,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：29毫秒','0','','2026-10-23 01:15:00','2026-10-23 01:15:00','2026-10-23 01:15:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (168,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-23 01:16:00','2026-10-23 01:16:00','2026-10-23 01:16:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (169,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-23 01:17:00','2026-10-23 01:17:00','2026-10-23 01:17:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (170,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:18:00','2026-10-23 01:18:00','2026-10-23 01:18:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (171,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:19:00','2026-10-23 01:19:00','2026-10-23 01:19:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (172,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:20:00','2026-10-23 01:20:00','2026-10-23 01:20:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (173,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:21:00','2026-10-23 01:21:00','2026-10-23 01:21:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (174,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 01:22:00','2026-10-23 01:22:00','2026-10-23 01:22:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (175,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 01:23:00','2026-10-23 01:23:00','2026-10-23 01:23:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (176,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:24:00','2026-10-23 01:24:00','2026-10-23 01:24:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (177,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:25:00','2026-10-23 01:25:00','2026-10-23 01:25:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (178,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:26:00','2026-10-23 01:26:00','2026-10-23 01:26:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (179,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:27:00','2026-10-23 01:27:00','2026-10-23 01:27:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (180,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:28:00','2026-10-23 01:28:00','2026-10-23 01:28:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (181,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-23 01:29:00','2026-10-23 01:29:00','2026-10-23 01:29:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (182,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:30:00','2026-10-23 01:30:00','2026-10-23 01:30:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (183,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:31:00','2026-10-23 01:31:00','2026-10-23 01:31:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (184,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:32:00','2026-10-23 01:32:00','2026-10-23 01:32:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (185,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：3毫秒','0','','2026-10-23 01:33:00','2026-10-23 01:33:00','2026-10-23 01:33:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (186,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 01:34:00','2026-10-23 01:34:00','2026-10-23 01:34:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (187,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：4毫秒','0','','2026-10-23 01:35:00','2026-10-23 01:35:00','2026-10-23 01:35:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (188,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 01:36:00','2026-10-23 01:36:00','2026-10-23 01:36:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (189,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:37:00','2026-10-23 01:37:00','2026-10-23 01:37:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (190,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：1毫秒','0','','2026-10-23 01:38:00','2026-10-23 01:38:00','2026-10-23 01:38:00');
INSERT INTO `sys_job_log` (`job_log_id`, `job_name`, `job_group`, `invoke_target`, `job_message`, `status`, `exception_info`, `start_time`, `end_time`, `create_time`) VALUES (191,'游戏商城超时关单','DEFAULT','gameshopOrderExpiry.closeExpired()','游戏商城超时关单 总共耗时：2毫秒','0','','2026-10-23 01:39:00','2026-10-23 01:39:00','2026-10-23 01:39:00');
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--
-- ORDER BY:  `info_id`,`status`,`login_time`

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (100,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-22 19:06:27');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (101,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-22 19:06:28');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (102,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-22 19:10:27');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (103,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-22 19:10:28');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (104,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-22 19:12:51');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (105,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-22 19:12:51');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (106,'admin','127.0.0.1','内网IP','Chrome 155','Windows10','1','验证码错误','2026-10-22 19:51:11');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (107,'admin','127.0.0.1','内网IP','Chrome 155','Windows10','0','登录成功','2026-10-22 19:51:15');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (108,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-22 22:28:57');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (109,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-22 22:28:58');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (110,'admin','127.0.0.1','内网IP','Chrome 155','Windows10','0','登录成功','2026-10-22 22:33:55');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (111,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-22 22:51:46');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (112,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-22 22:51:53');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (113,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-22 22:55:35');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (114,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-22 22:55:42');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (115,'admin','127.0.0.1','内网IP','Edge 155','Windows >=10','0','登录成功','2026-10-22 22:58:50');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (116,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-22 23:10:50');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (117,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-22 23:10:56');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (118,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-22 23:27:50');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (119,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-22 23:27:51');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (120,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-22 23:29:51');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (121,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-22 23:29:55');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (122,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-22 23:32:12');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (123,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-22 23:32:47');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (124,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-22 23:34:52');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (125,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-22 23:35:00');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (126,'admin','127.0.0.1','内网IP','Edge 155','Windows >=10','1','验证码错误','2026-10-23 00:35:29');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (127,'admin','127.0.0.1','内网IP','Edge 155','Windows >=10','0','登录成功','2026-10-23 00:35:29');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (128,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-23 00:37:34');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (129,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-23 00:37:41');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (130,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','登录成功','2026-10-23 01:13:06');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (131,'admin','127.0.0.1','内网IP','Python-Requests 2.32.5','','0','退出成功','2026-10-23 01:13:07');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (132,'admin','127.0.0.1','内网IP','Edge 155','Windows >=10','0','登录成功','2026-10-23 01:22:59');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (133,'admin','127.0.0.1','内网IP','Chrome 156.0.0.0','Windows >=10','0','登录成功','2026-10-23 01:29:24');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (134,'admin','127.0.0.1','内网IP','Chrome 156.0.0.0','Windows >=10','0','退出成功','2026-10-23 01:29:31');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES (135,'Mfenggg','127.0.0.1','内网IP','Edge 155','Windows >=10','0','登录成功','2026-10-23 01:34:35');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2037 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--
-- ORDER BY:  `menu_id`

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'系统管理',0,1,'system',NULL,'','',1,0,'M','0','0','','system','admin','2026-10-22 18:55:55','',NULL,'系统管理目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2026-10-22 18:55:55','',NULL,'用户管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2026-10-22 18:55:55','',NULL,'角色管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2026-10-22 18:55:55','',NULL,'菜单管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2026-10-22 18:55:55','',NULL,'字典管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2026-10-22 18:55:55','',NULL,'参数设置菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','0','system:notice:list','message','admin','2026-10-22 18:55:55','',NULL,'通知公告菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2026-10-22 18:55:55','',NULL,'日志管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2026-10-22 18:55:55','',NULL,'操作日志菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2026-10-22 18:55:55','',NULL,'登录日志菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2000,'游戏商城',0,0,'gameshop','',NULL,'Gameshop',1,1,'M','0','0','','shopping','migration','2026-10-22 22:13:57','migration','2026-10-22 22:49:26','');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2001,'游戏分类',2000,1,'categories','gameshop/categories/index',NULL,'GameshopCategories',1,1,'C','0','0','mall:category:list','tree','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2002,'游戏分类-query',2001,1,'','',NULL,'',1,1,'F','0','0','mall:category:query','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2003,'游戏分类-add',2001,2,'','',NULL,'',1,1,'F','0','0','mall:category:add','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2004,'游戏分类-edit',2001,3,'','',NULL,'',1,1,'F','0','0','mall:category:edit','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2005,'游戏分类-remove',2001,4,'','',NULL,'',1,1,'F','0','0','mall:category:remove','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2006,'道具商品',2000,2,'props','gameshop/props/index',NULL,'GameshopProps',1,1,'C','0','0','mall:prop:list','shopping','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2007,'道具商品-query',2006,1,'','',NULL,'',1,1,'F','0','0','mall:prop:query','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2008,'道具商品-add',2006,2,'','',NULL,'',1,1,'F','0','0','mall:prop:add','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2009,'道具商品-edit',2006,3,'','',NULL,'',1,1,'F','0','0','mall:prop:edit','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2010,'道具商品-remove',2006,4,'','',NULL,'',1,1,'F','0','0','mall:prop:remove','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2011,'道具商品-stock',2006,5,'','',NULL,'',1,1,'F','0','0','mall:prop:stock','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2012,'商城图片上传',2006,9,'','',NULL,'',1,1,'F','0','0','mall:media:upload','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2013,'首页轮播',2000,3,'banners','gameshop/banners/index',NULL,'GameshopBanners',1,1,'C','0','0','mall:banner:list','list','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2014,'首页轮播-query',2013,1,'','',NULL,'',1,1,'F','0','0','mall:banner:query','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2015,'首页轮播-add',2013,2,'','',NULL,'',1,1,'F','0','0','mall:banner:add','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2016,'首页轮播-edit',2013,3,'','',NULL,'',1,1,'F','0','0','mall:banner:edit','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2017,'首页轮播-remove',2013,4,'','',NULL,'',1,1,'F','0','0','mall:banner:remove','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2018,'商城会员',2000,4,'members','gameshop/members/index',NULL,'GameshopMembers',1,1,'C','0','0','mall:member:list','user','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2019,'商城会员-query',2018,1,'','',NULL,'',1,1,'F','0','0','mall:member:query','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2020,'商城会员-edit',2018,2,'','',NULL,'',1,1,'F','0','0','mall:member:edit','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2021,'商城订单',2000,5,'orders','gameshop/orders/index',NULL,'GameshopOrders',1,1,'C','0','0','mall:order:list','list','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2022,'商城订单-query',2021,1,'','',NULL,'',1,1,'F','0','0','mall:order:query','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2023,'商城订单-cancel',2021,2,'','',NULL,'',1,1,'F','0','0','mall:order:cancel','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2024,'商城订单-complete',2021,3,'','',NULL,'',1,1,'F','0','0','mall:order:complete','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2025,'商品评价',2000,6,'reviews','gameshop/reviews/index',NULL,'GameshopReviews',1,1,'C','0','0','mall:review:list','message','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2026,'商品评价-query',2025,1,'','',NULL,'',1,1,'F','0','0','mall:review:query','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2027,'商品评价-remove',2025,2,'','',NULL,'',1,1,'F','0','0','mall:review:remove','#','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2028,'库存流水',2000,7,'stock-logs','gameshop/stock-logs/index',NULL,'GameshopStockLogs',1,1,'C','0','0','mall:stock:list','log','migration','2026-10-22 22:13:57','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2029,'游戏区服',2000,8,'game-servers','gameshop/game-servers/index',NULL,'GameshopGameServers',1,1,'C','0','0','mall:server:list','tree','migration','2026-10-23 00:17:43','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2030,'区服查询',2029,1,'','',NULL,'',1,1,'F','0','0','mall:server:query','#','migration','2026-10-23 00:17:43','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2031,'区服新增',2029,2,'','',NULL,'',1,1,'F','0','0','mall:server:add','#','migration','2026-10-23 00:17:43','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2032,'区服修改',2029,3,'','',NULL,'',1,1,'F','0','0','mall:server:edit','#','migration','2026-10-23 00:17:43','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2033,'区服删除',2029,4,'','',NULL,'',1,1,'F','0','0','mall:server:remove','#','migration','2026-10-23 00:17:43','',NULL,'');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--
-- ORDER BY:  `notice_id`

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` (`notice_id`, `notice_title`, `notice_type`, `notice_content`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'商品上架检查','2',0x3C703EE58F91E5B883E6B8B8E6888FE98193E585B7E5898DEFBC8CE8AFB7E6A0B8E5AFB9E58886E7B1BBE38081E4BBB7E6A0BCE38081E58FAFE594AEE5BA93E5AD98E4B88EE4BAA4E4BB98E8AFB4E6988EEFBC8CE7A1AEE8AEA4E697A0E8AFAFE5908EE5868DE4B88AE69EB6E380823C2F703E,'0','admin','2026-10-22 18:55:55','migration','2026-10-22 22:50:29','管理员');
INSERT INTO `sys_notice` (`notice_id`, `notice_title`, `notice_type`, `notice_content`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'订单交付提醒','1',0x3C703EE5B7B2E694AFE4BB98E8AEA2E58D95E8AFB7E58F8AE697B6E5A484E79086E38082E5AE8CE68890E6B8B8E6888FE98193E585B7E4BAA4E4BB98E5908EEFBC8CE59CA8E59586E59F8EE8AEA2E58D95E4B8ADE799BBE8AEB0E4BAA4E4BB98E8AEB0E5BD95EFBC8CE5868DE5AE8CE68890E8AEA2E58D95E380823C2F703E,'0','admin','2026-10-22 18:55:55','migration','2026-10-22 22:50:29','管理员');
INSERT INTO `sys_notice` (`notice_id`, `notice_title`, `notice_type`, `notice_content`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'商城管理操作指引','1',0x3C703EE6ACA2E8BF8EE4BDBFE794A8E6B8B8E6888FE98193E585B7E59586E59F8EE7AEA1E79086E4B8ADE5BF83E380823C2F703E3C703EE59CA8E6B8B8E6888FE59586E59F8EE88F9CE58D95E4B8ADE7BBB4E68AA4E6B8B8E6888FE58886E7B1BBE38081E98193E585B7E59586E59381E5928CE9A696E9A1B5E8BDAEE692ADEFBC8CE5A484E79086E8AEA2E58D95E38081E7AEA1E79086E4BC9AE59198E4B88EE8AF84E4BBB7EFBC8CE5B9B6E9809AE8BF87E5BA93E5AD98E6B581E6B0B4E6A0B8E5AFB9E6AF8FE6ACA1E5BA93E5AD98E58F98E58C96E380823C2F703E,'0','admin','2026-10-22 18:55:56','migration','2026-10-22 22:49:26','管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice_read`
--

DROP TABLE IF EXISTS `sys_notice_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice_read` (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`),
  UNIQUE KEY `uk_user_notice` (`user_id`,`notice_id`) COMMENT '同一用户同一公告只记录一次'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公告已读记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice_read`
--
-- ORDER BY:  `read_id`,`user_id`,`notice_id`

LOCK TABLES `sys_notice_read` WRITE;
/*!40000 ALTER TABLE `sys_notice_read` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_notice_read` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--
-- ORDER BY:  `oper_id`,`business_type`,`status`,`oper_time`

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (100,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"tool/swagger/index\",\"createTime\":\"2026-10-22 18:55:55\",\"icon\":\"swagger\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":117,\"menuName\":\"系统接口\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":3,\"path\":\"swagger\",\"perms\":\"tool:swagger:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-22 23:00:16',27);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (101,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"tool/swagger/index\",\"createTime\":\"2026-10-22 18:55:55\",\"icon\":\"swagger\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":117,\"menuName\":\"系统接口\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":3,\"path\":\"swagger\",\"perms\":\"tool:swagger:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-22 23:00:38',6);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (102,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1060','127.0.0.1','内网IP','1060 ','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2026-10-22 23:00:47',3);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (103,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1060','127.0.0.1','内网IP','1060 ','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2026-10-22 23:00:50',2);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (104,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1060','127.0.0.1','内网IP','1060 ','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2026-10-22 23:00:56',2);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (105,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1058','127.0.0.1','内网IP','1058 ','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2026-10-22 23:01:05',2);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (106,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2026-10-22 18:55:55\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-22 23:05:38',34);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (107,'商城：后台上传商城图片',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminUploadMallImage()','POST',1,'admin','研发部门','/mall/media/images','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:52',450);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (108,'商城：后台上传商城图片',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminUploadMallImage()','POST',1,'admin','研发部门','/mall/media/images','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:52',238);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (109,'商城：后台上传商城图片',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminUploadMallImage()','POST',1,'admin','研发部门','/mall/media/images','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:52',236);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (110,'商城：后台上传商城图片',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminUploadMallImage()','POST',1,'admin','研发部门','/mall/media/images','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:53',253);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (111,'商城：后台上传商城图片',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminUploadMallImage()','POST',1,'admin','研发部门','/mall/media/images','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:53',209);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (112,'商城：后台上传商城图片',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminUploadMallImage()','POST',1,'admin','研发部门','/mall/media/images','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:53',223);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (113,'商城：后台上传商城图片',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminUploadMallImage()','POST',1,'admin','研发部门','/mall/media/images','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:53',218);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (114,'商城：后台创建分类',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminCreateCategory()','POST',1,'admin','研发部门','/mall/categories','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:53',9);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (115,'商城：后台创建分类',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminCreateCategory()','POST',1,'admin','研发部门','/mall/categories','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:53',5);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (116,'商城：后台创建分类',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminCreateCategory()','POST',1,'admin','研发部门','/mall/categories','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:53',5);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (117,'商城：后台创建道具',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminCreateProp()','POST',1,'admin','研发部门','/mall/props','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:54',100);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (118,'商城：后台创建道具',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminCreateProp()','POST',1,'admin','研发部门','/mall/props','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:54',16);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (119,'商城：后台创建道具',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminCreateProp()','POST',1,'admin','研发部门','/mall/props','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:54',14);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (120,'商城：后台创建道具',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminCreateProp()','POST',1,'admin','研发部门','/mall/props','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:54',13);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (121,'商城：后台创建道具',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminCreateProp()','POST',1,'admin','研发部门','/mall/props','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:54',13);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (122,'商城：后台创建道具',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminCreateProp()','POST',1,'admin','研发部门','/mall/props','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:54',14);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (123,'商城：后台创建轮播',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminCreateBanner()','POST',1,'admin','研发部门','/mall/banners','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:54',9);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (124,'商城：后台创建轮播',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminCreateBanner()','POST',1,'admin','研发部门','/mall/banners','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:54',6);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES (125,'商城：后台创建轮播',1,'com.ruoyi.gameshop.controller.AdminCatalogController.adminCreateBanner()','POST',1,'admin','研发部门','/mall/banners','127.0.0.1','内网IP',NULL,NULL,0,NULL,'2026-10-22 23:29:54',7);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--
-- ORDER BY:  `post_id`

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` (`post_id`, `post_code`, `post_name`, `post_sort`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'ceo','董事长',1,'0','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_post` (`post_id`, `post_code`, `post_name`, `post_sort`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'se','项目经理',2,'0','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_post` (`post_id`, `post_code`, `post_name`, `post_sort`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'hr','人力资源',3,'0','admin','2026-10-22 18:55:55','',NULL,'');
INSERT INTO `sys_post` (`post_id`, `post_code`, `post_name`, `post_sort`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,'user','普通员工',4,'0','admin','2026-10-22 18:55:55','',NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--
-- ORDER BY:  `role_id`

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` (`role_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2026-10-22 18:55:55','',NULL,'超级管理员');
INSERT INTO `sys_role` (`role_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'普通用户','common',2,'5',1,1,'0','0','admin','2026-10-22 18:55:55','migration','2026-10-23 01:11:36','仅限商城用户端；公开注册默认角色');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--
-- ORDER BY:  `role_id`,`dept_id`

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--
-- ORDER BY:  `role_id`,`menu_id`

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(254) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `phonenumber` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `sex` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '密码',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_sys_user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--
-- ORDER BY:  `user_id`,`user_name`

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` (`user_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `pwd_update_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,103,'admin','商城管理员','00','ry@163.com','15888888888','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-10-23 01:29:25','2026-10-22 18:55:55','admin','2026-10-22 18:55:55','migration','2026-10-22 22:49:26','管理员');
INSERT INTO `sys_user` (`user_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `pwd_update_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,105,'ry','商城运营','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-10-22 18:55:55','2026-10-22 18:55:55','admin','2026-10-22 18:55:55','migration','2026-10-22 22:49:26','测试员');
INSERT INTO `sys_user` (`user_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `pwd_update_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (100,NULL,'mfenggg','Mfenggg','00','admin@qq.com','','0','','$2a$12$CSl9AtPZa4kU/t2rbOekcuJrjlhXNVWaKgQrVsYayGRcto1Tn4UUS','0','0','127.0.0.1','2026-10-23 01:34:35','2026-10-23 01:11:36','mall-auth-v007','2026-10-22 23:44:07','',NULL,'商城历史账号迁移；保留原密码');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--
-- ORDER BY:  `user_id`,`post_id`

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` (`user_id`, `post_id`) VALUES (1,1);
INSERT INTO `sys_user_post` (`user_id`, `post_id`) VALUES (2,2);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--
-- ORDER BY:  `user_id`,`role_id`

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (1,1);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (2,2);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (100,2);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'gc_system'
--

--
-- Dumping routines for database 'gc_system'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-23  1:39:35
