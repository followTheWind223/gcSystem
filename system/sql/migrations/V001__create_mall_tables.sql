-- gcSystem 商城数据库 V001，契约 1.1.0。MySQL >= 8.0.16，InnoDB/utf8mb4。
-- 仅新增 mall_*，不删库、不删表、不修改若依 sys_*；整份 DDL 不具备原子回滚。
-- 首次执行前确认不存在 mall_*；重复执行应失败，禁止借 IF NOT EXISTS 掩盖结构漂移。
SET NAMES utf8mb4;
SET time_zone = '+08:00';

-- 商城增量脚本版本记录
CREATE TABLE `mall_schema_history` (
  `version` VARCHAR(16) NOT NULL COMMENT '已经完整执行的迁移版本，例如 V001',
  `script_name` VARCHAR(128) NOT NULL COMMENT '不可改写的脚本文件名',
  `description` VARCHAR(200) NOT NULL COMMENT '迁移说明',
  `installed_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '该脚本全部语句完成的记录时间',
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商城增量脚本版本记录';

-- 商城受控公开图片
CREATE TABLE `mall_media` (
  `media_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `stored_name` VARCHAR(37) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '32 位小写十六进制随机名加 .png/.jpg/.webp',
  `access_path` VARCHAR(80) GENERATED ALWAYS AS (CONCAT('/api/mall/media/', stored_name)) STORED NOT NULL COMMENT '从文件名生成同源 URL，不保存域名或磁盘绝对路径',
  `relative_path` VARCHAR(128) NOT NULL COMMENT '相对 UPLOAD_PATH 的服务器生成路径，例如 mall/2026/10/22/随机名.png；服务端规范化后必须在根目录内',
  `original_name` VARCHAR(255) NOT NULL COMMENT '去除目录和控制字符后的原始文件名',
  `mime_type` VARCHAR(32) NOT NULL COMMENT '重新编码后的实际 MIME：image/png、image/jpeg、image/webp',
  `file_size` INT NOT NULL COMMENT '编码后字节数，1–5242880；头像额外限制为 2097152',
  `width` INT NOT NULL COMMENT '图片宽度，1–4096 像素',
  `height` INT NOT NULL COMMENT '图片高度，1–4096 像素',
  `sha256` CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '编码后文件 SHA-256；用于完整性核对，不作为唯一键',
  `uploader_type` VARCHAR(6) NOT NULL COMMENT 'ADMIN 或 MEMBER；与 uploader_id 组成逻辑引用',
  `uploader_id` BIGINT NOT NULL COMMENT '按 uploader_type 关联 sys_user.user_id 或 mall_member.member_id，服务层验证，非物理外键',
  `uploader_name` VARCHAR(64) NOT NULL COMMENT '上传者账号快照，账号之后更名/删除不改历史',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '上传完成时间',
  PRIMARY KEY (`media_id`),
  UNIQUE KEY `uk_media_name` (`stored_name`),
  UNIQUE KEY `uk_media_path` (`access_path`),
  KEY `idx_media_uploader` (`uploader_type`,`uploader_id`,`create_time`),
  CONSTRAINT `ck_media_type` CHECK (mime_type IN ('image/png','image/jpeg','image/webp')),
  CONSTRAINT `ck_media_limits` CHECK (file_size BETWEEN 1 AND 5242880 AND width BETWEEN 1 AND 4096 AND height BETWEEN 1 AND 4096),
  CONSTRAINT `ck_media_uploader` CHECK (uploader_type IN ('ADMIN','MEMBER') AND uploader_id > 0),
  CONSTRAINT `ck_media_path` CHECK (relative_path LIKE 'mall/%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商城受控公开图片';

-- 独立商城会员
CREATE TABLE `mall_member` (
  `member_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `username` VARCHAR(20) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT 'trim 后小写，4–20 位字母/数字/下划线，首位字母；唯一',
  `password_hash` CHAR(60) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT 'BCrypt 密码散列，cost=12；禁止明文或 MD5；永不进入 VO',
  `nickname` VARCHAR(30) NOT NULL COMMENT '2–30 字符的展示昵称，注册省略时采用 username',
  `avatar_media_id` BIGINT NULL DEFAULT NULL COMMENT '头像关联受控媒体；默认无头像',
  `email` VARCHAR(254) COLLATE utf8mb4_bin NOT NULL COMMENT 'trim 后整体小写；数据库二进制排序比较归一化值；唯一',
  `email_verified` TINYINT NOT NULL DEFAULT 0 COMMENT '0 未验证，1 已验证；注册验码成功明确写 1',
  `phone_number` VARCHAR(20) NULL DEFAULT NULL COMMENT '可空联系方式；非空时 7–20 字符，格式由 DTO 校验',
  `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '0 正常，1 禁用，与商品状态含义相反',
  `session_version` BIGINT NOT NULL DEFAULT 0 COMMENT '会话版本；禁用、改密和重置密码时递增，所有旧会话必须失效',
  `status_reason` VARCHAR(200) NULL DEFAULT NULL COMMENT '最近一次启停原因；完整操作历史另留若依操作日志',
  `last_login_time` DATETIME(3) NULL DEFAULT NULL COMMENT '最近成功登录时间，首次未登录为空',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `uk_member_username` (`username`),
  UNIQUE KEY `uk_member_email` (`email`),
  KEY `idx_member_status_time` (`status`,`create_time`,`member_id`),
  CONSTRAINT `fk_member_avatar` FOREIGN KEY (`avatar_media_id`) REFERENCES `mall_media` (`media_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_member_username` CHECK (CHAR_LENGTH(username) BETWEEN 4 AND 20 AND username = LOWER(TRIM(username))),
  CONSTRAINT `ck_member_nickname` CHECK (CHAR_LENGTH(nickname) BETWEEN 2 AND 30),
  CONSTRAINT `ck_member_status` CHECK (status IN ('0','1') AND email_verified IN (0,1) AND session_version >= 0),
  CONSTRAINT `ck_member_disabled_reason` CHECK (status = '0' OR (status_reason IS NOT NULL AND CHAR_LENGTH(status_reason) BETWEEN 2 AND 200))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='独立商城会员';

-- 单层游戏分类
CREATE TABLE `mall_game_category` (
  `category_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `name` VARCHAR(30) NOT NULL COMMENT 'trim 后 2–30 字符；未删除分类中名称按 utf8mb4_unicode_ci 唯一',
  `icon_media_id` BIGINT NULL DEFAULT NULL COMMENT '分类图标，可空',
  `sort` INT NOT NULL DEFAULT 0 COMMENT '展示排序，0–9999，较小在前',
  `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '0 停用/下架，1 启用/上架',
  `recommended` TINYINT NOT NULL DEFAULT 0 COMMENT '0 普通，1 首页热门推荐',
  `version` INT NOT NULL DEFAULT 0 COMMENT '乐观锁版本；插入为 0，每次合法修改递增；库存操作也递增商品版本',
  `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '0 正常，2 软删除；公开查询必须过滤为 0',
  `active_name` VARCHAR(30) GENERATED ALWAYS AS (CASE WHEN del_flag = '0' THEN name ELSE NULL END) STORED NULL COMMENT '仅未删除行生成名称；软删除行生成 NULL，允许删除后重建同名分类',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  `create_by` VARCHAR(64) NOT NULL DEFAULT '' COMMENT '创建操作者账号快照，不作为鉴权依据',
  `update_by` VARCHAR(64) NOT NULL DEFAULT '' COMMENT '最后修改操作者账号快照',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uk_category_active_name` (`active_name`),
  KEY `idx_category_portal` (`del_flag`,`status`,`recommended`,`sort`,`category_id`),
  CONSTRAINT `fk_category_icon` FOREIGN KEY (`icon_media_id`) REFERENCES `mall_media` (`media_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_category_name` CHECK (CHAR_LENGTH(name) BETWEEN 2 AND 30),
  CONSTRAINT `ck_category_values` CHECK (status IN ('0','1') AND del_flag IN ('0','2') AND recommended IN (0,1) AND version >= 0 AND sort BETWEEN 0 AND 9999),
  CONSTRAINT `ck_category_deleted` CHECK (del_flag = '0' OR status = '0')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='单层游戏分类';

-- 单商品单库存道具
CREATE TABLE `mall_prop` (
  `prop_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `category_id` BIGINT NOT NULL COMMENT '所属分类，写入时必须是未删除分类',
  `name` VARCHAR(80) NOT NULL COMMENT '商品名称，2–80 字符',
  `cover_media_id` BIGINT NOT NULL COMMENT '封面媒体，服务层保证也在图片列表中',
  `price` DECIMAL(12,2) NOT NULL COMMENT '当前售价，大于 0；接口两位小数字符串',
  `original_price` DECIMAL(12,2) NULL DEFAULT NULL COMMENT '可空划线价，非空时不小于售价',
  `stock` INT NOT NULL DEFAULT 0 COMMENT '当前可售库存，0–1000000000；下单扣减，取消回补，支付不再扣',
  `sales` INT NOT NULL DEFAULT 0 COMMENT '成功支付的累计数量，只在首次支付成功时增加',
  `detail_html` MEDIUMTEXT NOT NULL COMMENT '清洗后的富文本，最多 20000 字符；MEDIUMTEXT 可容纳 utf8mb4 的完整字符容量',
  `spec_json` JSON NOT NULL COMMENT '最多 20 个 {name,value} 展示规格，不是 SKU',
  `delivery_fields_json` JSON NOT NULL COMMENT '1–3 个唯一字段名：gameAccount/serverName/roleName；枚举由服务层校验',
  `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '0 停用/下架，1 启用/上架',
  `on_sale_time` DATETIME(3) NULL DEFAULT NULL COMMENT '最近一次上架时间；从未上架可空，上架时必须有值',
  `version` INT NOT NULL DEFAULT 0 COMMENT '乐观锁版本；插入为 0，每次合法修改递增；库存操作也递增商品版本',
  `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '0 正常，2 软删除；公开查询必须过滤为 0',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  `create_by` VARCHAR(64) NOT NULL DEFAULT '' COMMENT '创建操作者账号快照，不作为鉴权依据',
  `update_by` VARCHAR(64) NOT NULL DEFAULT '' COMMENT '最后修改操作者账号快照',
  PRIMARY KEY (`prop_id`),
  KEY `idx_prop_new` (`del_flag`,`status`,`on_sale_time` DESC,`prop_id` DESC),
  KEY `idx_prop_category_new` (`category_id`,`del_flag`,`status`,`on_sale_time` DESC,`prop_id` DESC),
  KEY `idx_prop_price` (`del_flag`,`status`,`price`,`prop_id`),
  KEY `idx_prop_sales` (`del_flag`,`status`,`sales` DESC,`prop_id` DESC),
  CONSTRAINT `fk_prop_category` FOREIGN KEY (`category_id`) REFERENCES `mall_game_category` (`category_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_prop_cover` FOREIGN KEY (`cover_media_id`) REFERENCES `mall_media` (`media_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_prop_money` CHECK (price > 0 AND (original_price IS NULL OR original_price >= price)),
  CONSTRAINT `ck_prop_stock` CHECK (stock BETWEEN 0 AND 1000000000 AND sales BETWEEN 0 AND 2147483647 AND version >= 0),
  CONSTRAINT `ck_prop_text` CHECK (CHAR_LENGTH(name) BETWEEN 2 AND 80 AND CHAR_LENGTH(detail_html) <= 20000),
  CONSTRAINT `ck_prop_json` CHECK (JSON_TYPE(spec_json) = 'ARRAY' AND JSON_LENGTH(spec_json) <= 20 AND JSON_TYPE(delivery_fields_json) = 'ARRAY' AND JSON_LENGTH(delivery_fields_json) BETWEEN 1 AND 3),
  CONSTRAINT `ck_prop_state` CHECK (status IN ('0','1') AND del_flag IN ('0','2') AND (status = '0' OR on_sale_time IS NOT NULL) AND (del_flag = '0' OR status = '0'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='单商品单库存道具';

-- 商品多图关联
CREATE TABLE `mall_prop_image` (
  `image_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `prop_id` BIGINT NOT NULL COMMENT '所属商品',
  `media_id` BIGINT NOT NULL COMMENT '图片媒体',
  `sort` INT NOT NULL DEFAULT 0 COMMENT '0–9999，同排序时 image_id 升序',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '关联创建时间',
  PRIMARY KEY (`image_id`),
  UNIQUE KEY `uk_prop_image_media` (`prop_id`,`media_id`),
  KEY `idx_prop_image_sort` (`prop_id`,`sort`,`image_id`),
  CONSTRAINT `fk_prop_image_prop` FOREIGN KEY (`prop_id`) REFERENCES `mall_prop` (`prop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_prop_image_media` FOREIGN KEY (`media_id`) REFERENCES `mall_media` (`media_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_prop_image_sort` CHECK (sort BETWEEN 0 AND 9999)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品多图关联';

-- 首页内部商品轮播
CREATE TABLE `mall_banner` (
  `banner_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `title` VARCHAR(60) NOT NULL COMMENT '1–60 字符标题',
  `image_media_id` BIGINT NOT NULL COMMENT '轮播图媒体',
  `target_prop_id` BIGINT NOT NULL COMMENT '内部目标商品，不允许任意外链',
  `sort` INT NOT NULL DEFAULT 0 COMMENT '0–9999 排序值',
  `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '0 停用/下架，1 启用/上架',
  `version` INT NOT NULL DEFAULT 0 COMMENT '乐观锁版本；插入为 0，每次合法修改递增；库存操作也递增商品版本',
  `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '0 正常，2 软删除；公开查询必须过滤为 0',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  `create_by` VARCHAR(64) NOT NULL DEFAULT '' COMMENT '创建操作者账号快照，不作为鉴权依据',
  `update_by` VARCHAR(64) NOT NULL DEFAULT '' COMMENT '最后修改操作者账号快照',
  PRIMARY KEY (`banner_id`),
  KEY `idx_banner_portal` (`del_flag`,`status`,`sort`,`banner_id`),
  CONSTRAINT `fk_banner_image` FOREIGN KEY (`image_media_id`) REFERENCES `mall_media` (`media_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_banner_target` FOREIGN KEY (`target_prop_id`) REFERENCES `mall_prop` (`prop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_banner_values` CHECK (CHAR_LENGTH(title) BETWEEN 1 AND 60 AND sort BETWEEN 0 AND 9999 AND version >= 0 AND status IN ('0','1') AND del_flag IN ('0','2') AND (del_flag = '0' OR status = '0'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='首页内部商品轮播';

-- 当前购物车项目
CREATE TABLE `mall_cart_item` (
  `cart_item_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `member_id` BIGINT NOT NULL COMMENT '会员归属，只从认证上下文取得',
  `prop_id` BIGINT NOT NULL COMMENT '关联商品，失效时仍保留购物车行',
  `quantity` TINYINT UNSIGNED NOT NULL COMMENT '1–99，POST 是增量，PUT 是绝对值',
  `checked` TINYINT NOT NULL DEFAULT 1 COMMENT '0 未勾选，1 勾选；不是结算的隐式范围',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  PRIMARY KEY (`cart_item_id`),
  UNIQUE KEY `uk_cart_member_prop` (`member_id`,`prop_id`),
  KEY `idx_cart_member_updated` (`member_id`,`update_time` DESC,`cart_item_id` DESC),
  CONSTRAINT `fk_cart_member` FOREIGN KEY (`member_id`) REFERENCES `mall_member` (`member_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_cart_prop` FOREIGN KEY (`prop_id`) REFERENCES `mall_prop` (`prop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_cart_values` CHECK (quantity BETWEEN 1 AND 99 AND checked IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='当前购物车项目';

-- 不可物理删除的订单主表
CREATE TABLE `mall_order` (
  `order_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `order_no` VARCHAR(40) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '服务器生成的 16–40 位大写字母数字订单号，全局唯一',
  `member_id` BIGINT NOT NULL COMMENT '下单会员，构成订单归属；从认证上下文取得',
  `source` VARCHAR(6) NOT NULL COMMENT 'DIRECT 或 CART，来自报价快照',
  `request_key` CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '规范化小写 UUID；同会员同键永不重复建单',
  `request_hash` CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '规范化 quoteToken/交付字段/备注的 SHA-256，仅用于精确重放，不保存原始令牌',
  `total_amount` DECIMAL(12,2) NOT NULL COMMENT '各明细 subtotal 之和，大于 0，由服务端计算',
  `total_quantity` SMALLINT UNSIGNED NOT NULL COMMENT '各明细数量之和，1–4950',
  `item_count` TINYINT UNSIGNED NOT NULL COMMENT '不同商品明细行数，1–50',
  `currency` CHAR(3) NOT NULL DEFAULT 'CNY' COMMENT '首版固定人民币',
  `status` CHAR(1) NOT NULL DEFAULT '1' COMMENT '1 待支付，2 已支付，3 已取消，4 已完成',
  `delivery_info_json` JSON NOT NULL COMMENT '本单交付信息快照，三字段可空：gameAccount/serverName/roleName；禁止存游戏密码',
  `remark` VARCHAR(200) NULL DEFAULT NULL COMMENT '买家备注，trim 后空白归 null',
  `cancel_reason` VARCHAR(200) NULL DEFAULT NULL COMMENT '取消原因，取消状态必填',
  `expire_time` DATETIME(3) NOT NULL COMMENT '创建后默认 30 分钟，过期不可支付',
  `paid_time` DATETIME(3) NULL DEFAULT NULL COMMENT '首次成功支付时间',
  `cancelled_time` DATETIME(3) NULL DEFAULT NULL COMMENT '实际取消/关单时间',
  `completed_time` DATETIME(3) NULL DEFAULT NULL COMMENT '登记交付并完成的时间',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  UNIQUE KEY `uk_order_member_request` (`member_id`,`request_key`),
  UNIQUE KEY `uk_order_owner` (`order_id`,`member_id`),
  KEY `idx_order_member_time` (`member_id`,`create_time` DESC,`order_id` DESC),
  KEY `idx_order_member_state_time` (`member_id`,`status`,`create_time` DESC,`order_id` DESC),
  KEY `idx_order_expiry` (`status`,`expire_time`,`order_id`),
  KEY `idx_order_admin_time` (`create_time` DESC,`order_id` DESC),
  CONSTRAINT `fk_order_member` FOREIGN KEY (`member_id`) REFERENCES `mall_member` (`member_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_order_money_counts` CHECK (total_amount > 0 AND total_quantity BETWEEN 1 AND 4950 AND item_count BETWEEN 1 AND 50),
  CONSTRAINT `ck_order_source` CHECK (source IN ('DIRECT','CART') AND currency = 'CNY' AND CHAR_LENGTH(request_key) = 36 AND CHAR_LENGTH(request_hash) = 64 AND JSON_TYPE(delivery_info_json) = 'OBJECT'),
  CONSTRAINT `ck_order_time` CHECK (expire_time > create_time AND (paid_time IS NULL OR (paid_time >= create_time AND paid_time < expire_time)) AND (cancelled_time IS NULL OR cancelled_time >= create_time) AND (completed_time IS NULL OR completed_time >= paid_time)),
  CONSTRAINT `ck_order_state_times` CHECK ((status = '1' AND paid_time IS NULL AND cancelled_time IS NULL AND completed_time IS NULL) OR (status = '2' AND paid_time IS NOT NULL AND cancelled_time IS NULL AND completed_time IS NULL) OR (status = '3' AND paid_time IS NULL AND cancelled_time IS NOT NULL AND completed_time IS NULL AND cancel_reason IS NOT NULL) OR (status = '4' AND paid_time IS NOT NULL AND cancelled_time IS NULL AND completed_time IS NOT NULL))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='不可物理删除的订单主表';

-- 订单商品不可变快照
CREATE TABLE `mall_order_item` (
  `order_item_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `order_id` BIGINT NOT NULL COMMENT '所属订单',
  `prop_id` BIGINT NOT NULL COMMENT '商品历史关联；软删除后仍保留',
  `prop_name` VARCHAR(80) NOT NULL COMMENT '下单时商品名称快照，不随改名变更',
  `cover_url` VARCHAR(80) NOT NULL COMMENT '下单时受控图片 URL 快照',
  `spec_json` JSON NOT NULL COMMENT '下单时展示规格快照',
  `unit_price` DECIMAL(12,2) NOT NULL COMMENT '下单时真实单价，不随调价变更',
  `quantity` TINYINT UNSIGNED NOT NULL COMMENT '1–99，合并后的购买数量',
  `subtotal` DECIMAL(12,2) GENERATED ALWAYS AS (unit_price * quantity) STORED NOT NULL COMMENT '数据库生成列；INSERT/UPDATE 不允许赋值；服务端还需检查总额容量',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '快照创建时间',
  PRIMARY KEY (`order_item_id`),
  UNIQUE KEY `uk_order_item_prop` (`order_id`,`prop_id`),
  UNIQUE KEY `uk_order_item_identity` (`order_item_id`,`order_id`,`prop_id`),
  CONSTRAINT `fk_item_order` FOREIGN KEY (`order_id`) REFERENCES `mall_order` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_item_prop` FOREIGN KEY (`prop_id`) REFERENCES `mall_prop` (`prop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_order_item_values` CHECK (unit_price > 0 AND quantity BETWEEN 1 AND 99 AND JSON_TYPE(spec_json) = 'ARRAY')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单商品不可变快照';

-- 唯一成功模拟支付事实
CREATE TABLE `mall_payment_record` (
  `payment_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `order_id` BIGINT NOT NULL COMMENT '所属订单，一个订单至多一条成功支付',
  `payment_no` VARCHAR(40) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '全局唯一成功支付编号',
  `channel` VARCHAR(8) NOT NULL DEFAULT 'MOCK' COMMENT '首版仅 MOCK',
  `amount` DECIMAL(12,2) NOT NULL COMMENT '与订单快照金额相等，由支付事务校验',
  `paid_time` DATETIME(3) NOT NULL COMMENT '成功支付发生时间，与订单 paid_time 同值',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '事实落库时间',
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `uk_payment_order` (`order_id`),
  UNIQUE KEY `uk_payment_no` (`payment_no`),
  CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `mall_order` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_payment_values` CHECK (channel = 'MOCK' AND amount > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='唯一成功模拟支付事实';

-- 唯一虚拟交付事实
CREATE TABLE `mall_order_delivery` (
  `delivery_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `order_id` BIGINT NOT NULL COMMENT '所属订单，一单至多一次完成交付',
  `delivery_note` VARCHAR(1000) NOT NULL COMMENT '2–1000 字符交付说明，购买会员可见，禁止游戏密码',
  `operator_admin_id` BIGINT NOT NULL COMMENT '后台操作者 ID，逻辑关联 sys_user；从认证上下文取得',
  `operator_name` VARCHAR(64) NOT NULL COMMENT '操作者账号快照，防止后台账号后来删除导致历史丢失',
  `delivered_time` DATETIME(3) NOT NULL COMMENT '交付完成时间，与订单 completed_time 同值',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录落库时间',
  PRIMARY KEY (`delivery_id`),
  UNIQUE KEY `uk_delivery_order` (`order_id`),
  CONSTRAINT `fk_delivery_order` FOREIGN KEY (`order_id`) REFERENCES `mall_order` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_delivery_values` CHECK (CHAR_LENGTH(delivery_note) BETWEEN 2 AND 1000 AND operator_admin_id > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='唯一虚拟交付事实';

-- 只追加订单状态流水
CREATE TABLE `mall_order_log` (
  `log_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `order_id` BIGINT NOT NULL COMMENT '所属订单',
  `from_status` CHAR(1) NULL DEFAULT NULL COMMENT '初始建单为 null，否则是本次动作的旧状态',
  `to_status` CHAR(1) NOT NULL COMMENT '本次动作后的新状态',
  `operator_type` VARCHAR(6) NOT NULL COMMENT 'ADMIN、MEMBER、SYSTEM，多态操作者类型',
  `operator_id` BIGINT NULL DEFAULT NULL COMMENT '按类型逻辑关联 sys_user 或 mall_member；SYSTEM 必须 null',
  `operator_name` VARCHAR(64) NULL DEFAULT NULL COMMENT '账号快照；SYSTEM 使用 system',
  `reason` VARCHAR(1000) NOT NULL COMMENT '动作说明；完整交付说明存交付表，取消原因同时存订单快照',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '状态变化时间',
  PRIMARY KEY (`log_id`),
  UNIQUE KEY `uk_order_log_state` (`order_id`,`to_status`),
  KEY `idx_order_log_timeline` (`order_id`,`create_time`,`log_id`),
  CONSTRAINT `fk_order_log_order` FOREIGN KEY (`order_id`) REFERENCES `mall_order` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_order_log_transition` CHECK ((from_status IS NULL AND to_status = '1') OR (from_status = '1' AND to_status IN ('2','3')) OR (from_status = '2' AND to_status = '4')),
  CONSTRAINT `ck_order_log_operator` CHECK ((operator_type = 'SYSTEM' AND operator_id IS NULL) OR (operator_type IN ('ADMIN','MEMBER') AND operator_id IS NOT NULL AND operator_id > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='只追加订单状态流水';

-- 只追加库存流水及库存调整幂等凭据
CREATE TABLE `mall_stock_log` (
  `stock_log_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `prop_id` BIGINT NOT NULL COMMENT '商品关联',
  `prop_name` VARCHAR(80) NOT NULL COMMENT '库存变动时商品名称快照',
  `change_qty` INT NOT NULL COMMENT '本次增减量，初始库存允许 0，库存调整不允许 0',
  `before_stock` INT NOT NULL COMMENT '变更前库存，必须在锁/原子更新事务中取得',
  `after_stock` INT NOT NULL COMMENT '变更后库存，必须等于 before_stock+change_qty',
  `biz_type` VARCHAR(16) NOT NULL COMMENT 'INITIAL/ORDER_RESERVE/ORDER_RELEASE/ADMIN_ADJUST',
  `biz_key` VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT 'INITIAL=商品 ID；订单类=orderNo；调整=requestKey',
  `request_hash` CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT 'ADMIN_ADJUST 时必填，摘要包含 propId/operatorId/delta/reason；其他类型可空',
  `order_id` BIGINT NULL DEFAULT NULL COMMENT '订单扣减/回补时必填，初始和人工调整为 null',
  `operator_type` VARCHAR(6) NOT NULL COMMENT 'ADMIN、MEMBER、SYSTEM，多态操作者类型',
  `operator_id` BIGINT NULL DEFAULT NULL COMMENT '按类型逻辑关联 sys_user 或 mall_member；SYSTEM 必须 null',
  `operator_name` VARCHAR(64) NULL DEFAULT NULL COMMENT '账号快照；SYSTEM 使用 system',
  `reason` VARCHAR(200) NOT NULL COMMENT '库存变动或人工调整原因',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '变动时间',
  PRIMARY KEY (`stock_log_id`),
  UNIQUE KEY `uk_stock_biz` (`prop_id`,`biz_type`,`biz_key`),
  KEY `idx_stock_prop_time` (`prop_id`,`create_time` DESC,`stock_log_id` DESC),
  KEY `idx_stock_type_time` (`biz_type`,`create_time` DESC,`stock_log_id` DESC),
  CONSTRAINT `fk_stock_prop` FOREIGN KEY (`prop_id`) REFERENCES `mall_prop` (`prop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_stock_order` FOREIGN KEY (`order_id`) REFERENCES `mall_order` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_stock_arithmetic` CHECK (before_stock BETWEEN 0 AND 1000000000 AND after_stock BETWEEN 0 AND 1000000000 AND change_qty BETWEEN -1000000000 AND 1000000000 AND after_stock = before_stock + change_qty),
  CONSTRAINT `ck_stock_biz` CHECK ((biz_type = 'INITIAL' AND before_stock = 0 AND change_qty >= 0 AND order_id IS NULL) OR (biz_type = 'ORDER_RESERVE' AND change_qty < 0 AND order_id IS NOT NULL) OR (biz_type = 'ORDER_RELEASE' AND change_qty > 0 AND order_id IS NOT NULL) OR (biz_type = 'ADMIN_ADJUST' AND change_qty <> 0 AND order_id IS NULL AND request_hash IS NOT NULL)),
  CONSTRAINT `ck_stock_operator` CHECK ((operator_type = 'SYSTEM' AND operator_id IS NULL) OR (operator_type IN ('ADMIN','MEMBER') AND operator_id IS NOT NULL AND operator_id > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='只追加库存流水及库存调整幂等凭据';

-- 每条已完成订单明细唯一评价
CREATE TABLE `mall_review` (
  `review_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自增主键；应用只使用正数，接口序列化为字符串',
  `member_id` BIGINT NOT NULL COMMENT '评价会员，与订单归属组成复合外键',
  `order_id` BIGINT NOT NULL COMMENT '订单关联',
  `order_item_id` BIGINT NOT NULL COMMENT '唯一被评价明细，隐藏也不释放唯一约束',
  `prop_id` BIGINT NOT NULL COMMENT '商品关联，与明细组合外键保证一致',
  `score` TINYINT NOT NULL COMMENT '1–5 整数评分',
  `content` VARCHAR(1000) NOT NULL COMMENT '5–1000 字符纯文本，不解析 HTML',
  `status` VARCHAR(7) NOT NULL DEFAULT 'VISIBLE' COMMENT 'VISIBLE 或 HIDDEN',
  `hide_reason` VARCHAR(200) NULL DEFAULT NULL COMMENT '隐藏原因，隐藏时必填',
  `hidden_by` BIGINT NULL DEFAULT NULL COMMENT '隐藏操作者后台 ID，逻辑关联 sys_user',
  `hidden_time` DATETIME(3) NULL DEFAULT NULL COMMENT '隐藏时间',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录创建时间，数据库会话为 +08:00',
  `update_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '记录最近修改时间；更新行时由数据库刷新',
  PRIMARY KEY (`review_id`),
  UNIQUE KEY `uk_review_order_item` (`order_item_id`),
  KEY `idx_review_public` (`prop_id`,`status`,`create_time` DESC,`review_id` DESC),
  KEY `idx_review_member` (`member_id`,`create_time` DESC,`review_id` DESC),
  CONSTRAINT `fk_review_owner` FOREIGN KEY (`order_id`,`member_id`) REFERENCES `mall_order` (`order_id`,`member_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_review_item` FOREIGN KEY (`order_item_id`,`order_id`,`prop_id`) REFERENCES `mall_order_item` (`order_item_id`,`order_id`,`prop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_review_content` CHECK (score BETWEEN 1 AND 5 AND CHAR_LENGTH(content) BETWEEN 5 AND 1000),
  CONSTRAINT `ck_review_visibility` CHECK ((status = 'VISIBLE' AND hide_reason IS NULL AND hidden_by IS NULL AND hidden_time IS NULL) OR (status = 'HIDDEN' AND hide_reason IS NOT NULL AND CHAR_LENGTH(hide_reason) BETWEEN 2 AND 200 AND hidden_by IS NOT NULL AND hidden_by > 0 AND hidden_time IS NOT NULL))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='每条已完成订单明细唯一评价';

INSERT INTO mall_schema_history(version,script_name,description) VALUES ('V001','V001__create_mall_tables.sql','创建 14 张商城业务表及迁移版本表');
