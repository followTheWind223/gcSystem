<script setup>
import { onMounted, onUnmounted } from 'vue'
import { catalogApi } from '../api/mall.js'
import { useRequest } from '../composables/useRequest.js'
import Icon from '../components/Icon.vue'
import ProductCard from '../components/ProductCard.vue'
import StatePanel from '../components/StatePanel.vue'
import HeroCarousel from '../components/HeroCarousel.vue'
const { data, error, loading, load } = useRequest(async () => { const [home, categories] = await Promise.all([catalogApi.home(), catalogApi.categories()]); return { ...home.data, categories: categories.data } })
onMounted(() => { load(); window.addEventListener('mall-demo-change', load) })
onUnmounted(() => window.removeEventListener('mall-demo-change', load))
</script>
<template><div class="container home-view">
  <div class="welcome-row"><p><span class="status-dot" /> 装备就绪，冒险继续</p><RouterLink to="/me/orders">我的订单<Icon name="chevron" :size="14" /></RouterLink></div>
  <StatePanel :loading="loading" :error="error" @retry="load">
    <template v-if="data">
      <section class="hero-grid" aria-label="精选推荐">
        <HeroCarousel :banners="data.banners" />
        <div class="hero-side"><div class="side-label"><span class="eyebrow">YOUR NEXT UPGRADE</span><Icon name="spark" :size="27" /></div><h2>为你的热爱，<br />添一份<span>战力。</span></h2><p>穿梭不同游戏世界<br />找到属于你的下一件装备</p><div class="side-symbol"><Icon name="game" :size="70" /></div><RouterLink to="/props?sort=on_sale_desc">发现新上架<Icon name="arrow" :size="18" /></RouterLink></div>
      </section>
      <section class="home-section"><div class="section-heading"><div><h2>选择你的游戏<span>FIND YOUR WORLD</span></h2></div><RouterLink to="/props">查看全部<Icon name="arrow" :size="16" /></RouterLink></div><div class="game-categories"><RouterLink v-for="(category, i) in data.hotCategories" :key="category.categoryId" :to="{ name: 'catalog', query: { categoryId: category.categoryId } }" class="game-category" :class="`game-${i % 4}`"><span class="game-emblem"><Icon :name="['spark', 'shield', 'bolt', 'game'][i % 4]" :size="30" /></span><span><strong>{{ category.name }}</strong><small>{{ ['探索星海，无尽征途', '史诗装备，永恒冒险', '未来战场，即刻集结', '踏入秘境，发现惊喜'][i % 4] }}</small></span><Icon name="chevron" :size="17" /></RouterLink></div></section>
      <section class="home-section"><div class="section-heading"><div><h2><Icon name="flame" :size="23" />热门道具<span>GEAR UP, GAME ON</span></h2><p>玩家的心仪之选，你的下一件装备</p></div><RouterLink to="/props?sort=sales_desc">探索更多<Icon name="arrow" :size="16" /></RouterLink></div><StatePanel :empty="!data.hotProps.length" title="精选道具即将上架"><div class="product-grid home-products"><ProductCard v-for="(product, i) in data.hotProps" :key="product.propId" :product="product" :index="i" /></div></StatePanel></section>
      <div class="explore-banner"><div><span class="eyebrow">READY FOR YOUR NEXT QUEST?</span><h2>你的下一件装备，就在这里。</h2><p>从一件心仪道具，开始新的游戏故事。</p></div><RouterLink to="/props" class="btn secondary">探索全部道具<Icon name="arrow" :size="18" /></RouterLink></div>
    </template>
  </StatePanel>
</div></template>
