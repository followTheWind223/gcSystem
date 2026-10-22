<template>
  <section class="shop-auth-brand" aria-label="游戏道具商城管理中心">
    <div class="brand-name"><img src="/brand.svg" alt="" /><span>游戏道具商城</span></div>
    <div class="brand-intro">
      <span class="brand-caption">管理中心</span>
      <h1>商品有序上架<br />订单及时交付</h1>
      <p>让每一笔游戏道具交易都有迹可循。</p>
      <ul><li>商品与库存</li><li>订单与交付</li><li>会员与评价</li></ul>
    </div>
    <div class="brand-bottom">GAME ITEM SHOP · ADMIN</div>
  </section>
</template>

<style scoped>
.shop-auth-brand { width: 480px; min-height: 530px; padding: 42px; color: #fff; background: #182b45; border-radius: 16px 0 0 16px; display: flex; flex-direction: column; justify-content: space-between; }
.brand-name { display: flex; align-items: center; gap: 12px; font-size: 18px; font-weight: 600; letter-spacing: 1px; }.brand-name img { width: 40px; height: 40px; }
.brand-intro { padding: 45px 0; }.brand-caption { color: #a9c2e0; font-size: 13px; letter-spacing: 3px; }h1 { font-size: 32px; font-weight: 600; line-height: 1.65; margin: 15px 0; }p { color: #c2cede; font-size: 14px; line-height: 1.8; }
ul { list-style: none; display: flex; flex-wrap: wrap; gap: 16px; margin: 28px 0 0; padding: 0; font-size: 12px; color: #dce6f3; }li { border-bottom: 2px solid #b98a3b; padding-bottom: 8px; }
.brand-bottom { font-size: 10px; color: #a9bcd4; letter-spacing: 2px; }
@media(max-width: 850px) { .shop-auth-brand { width: 100%; min-height: auto; padding: 22px 28px; border-radius: 14px 14px 0 0; }.brand-intro,.brand-bottom { display: none; }.brand-name { font-size: 17px; }.brand-name img { width: 34px; height: 34px; } }
</style>
