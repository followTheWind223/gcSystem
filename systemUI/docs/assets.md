# 原创界面素材

两张图片使用内置 image_gen 工具生成，作为虚构游戏道具演示与商城视觉素材，不对应现有游戏 IP。原图已复制到本工程 `public/images/`，运行不依赖外部图片站点。UI 图标为本地 SVG 路径。品牌为 `gameshop`；按用户要求，原 `gs` 字母块已替换为“游戏手柄＋道具晶石”标志，直接编辑原生矢量路径，仍保存在 `public/gs-logo.svg`，不使用生成位图。`src/components/BrandLogo.vue` 共用图形、白绿双色字标与中文说明，同步用于页头、页脚及桌面/手机认证主体。浏览器图标使用同一 SVG，缓存版本为 `v=2`。

- `public/images/hero-sword.png`：1536×1024，首页推荐横幅、账号页背景。
- `public/images/item-atlas.png`：1536×1024，3×2 原创道具图集，通过 `ItemArt.vue` 的 CSS 背景定位展示六件道具；Mock 层采用 `#0`～`#5` 区分图块。真实接口仅使用契约媒体路径，不硬编码演示道具图片。

## 最终生成提示

### 主视觉

Use case: stylized-concept. Asset type: original fantasy video game item storefront hero image, wide landscape 1536x1024. A single elaborate futuristic fantasy longsword floating diagonally from lower left to upper right, intricate black gunmetal hilt, polished silver double-edge blade with a luminous jade-teal energy core and finely engraved geometric runes. Behind sword a subtle monumental circular mechanical portal ring and dark craggy rock pedestal, small drifting teal particles. High-end game cinematic 3D render, meticulously crafted material details, sharp sword, moody studio rim lights, deep charcoal almost-black background with very subtle teal fog. Weapon occupies right 65 percent of frame, left 35 percent near-black negative space for webpage text. No people, no letters, no words, no watermark, no UI, no logo. Palette: charcoal, silver, muted emerald, white highlights. Original design, not any existing game IP.

### 道具图集

Use case: stylized-concept. Asset type: single game-item catalog sprite atlas with exactly 6 independent square tiles in 3 columns and 2 rows, landscape 1536x1024. Each tile has an identical flat very dark charcoal #161b20 background, no borders, cleanly aligned 3x2 grid. Each object is isolated fully within its tile with generous space, centered and completely visible, luxurious ultra detailed fantasy RPG inventory item 3D render. Top left: ornate silver longsword glowing teal, diagonal. Top middle: elegant golden black recurve bow with amber glowing string, diagonal. Top right: large silver and violet celestial butterfly-wing amulet with purple gem. Bottom left: faceted floating cyan ice crystal cluster with silver rune ring. Bottom middle: elaborate brass treasure chest opened with soft golden glow, three quarter view. Bottom right: a red and black futuristic science-fiction combat helmet with vivid red light accents, three quarter view. Lighting individually dramatic, beautiful physically based metals, original game asset designs, no game trademarks. Keep ALL items distinct, not overlapping between tiles. NO text, NO letters, NO numbers, NO UI, NO labels, NO watermark. Precise grid suitable for CSS background-size 300% 200%.
