<script setup>
import { ref, computed, defineAsyncComponent, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import Icon from './components/Icon.vue'
import BrandLogo from './components/BrandLogo.vue'
import AuthLayout from './layouts/AuthLayout.vue'
import { useAuthStore } from './stores/auth.js'
import { useCartStore } from './stores/cart.js'
import { useCheckoutStore } from './stores/checkout.js'
const DemoTools = import.meta.env.VITE_USE_MOCK === 'true' ? defineAsyncComponent(() => import('./components/DemoTools.vue')) : null
const auth = useAuthStore(), cart = useCartStore(), checkout = useCheckoutStore(), route = useRoute(), router = useRouter(), keyword = ref(''), menu = ref(false)
const navigation = [
  { key: 'home', to: '/', label: '探索商城' },
  { key: 'catalog', to: '/props', label: '全部道具' },
  { key: 'new', to: '/props?sort=on_sale_desc', label: '新品上架' },
]
const mobileNavigation = [...navigation, { key: 'orders', to: '/me/orders', label: '我的订单' }]
// Catalog tabs share a route; select one using its query instead of RouterLink's path-only matching.
const activeNavigation = computed(() => {
  if (route.name === 'home') return 'home'
  if (route.name === 'catalog') return route.query.sort === 'on_sale_desc' ? 'new' : 'catalog'
  if (route.name === 'prop') return 'catalog'
  if (['order', 'pay'].includes(route.name) || (route.name === 'account' && route.params.section === 'orders')) return 'orders'
  return null
})
watch(() => route.fullPath, () => { menu.value = false; keyword.value = typeof route.query.keyword === 'string' ? route.query.keyword : '' })
watch(() => auth.token, token => { if (token) cart.load().catch(() => {}) })
function search() { router.push({ name: 'catalog', query: keyword.value.trim() ? { keyword: keyword.value.trim() } : {} }) }
async function logout() { try { await auth.logout() } catch { ElMessage.info('你已退出登录') } finally { cart.clear(); checkout.clear(); router.push('/') } }
</script>
<template>
  <AuthLayout v-if="route.meta.layout === 'auth'"><RouterView :key="route.name" /></AuthLayout>
  <div v-else class="storefront-layout">
  <a class="skip-link" href="#main-content">跳转到主要内容</a>
  <header class="site-header"><div class="container header-content">
    <RouterLink to="/" class="brand" aria-label="gameshop首页"><BrandLogo /></RouterLink>
    <nav class="desktop-nav" aria-label="主导航">
      <RouterLink v-for="item in navigation" :key="item.key" :to="item.to" custom v-slot="{ href, navigate }">
        <a :href="href" :class="{ active: activeNavigation === item.key }" :aria-current="activeNavigation === item.key ? 'page' : undefined" @click="navigate">{{ item.label }}<span v-if="item.key === 'new'" class="new-dot" /></a>
      </RouterLink>
    </nav>
    <form class="header-search" role="search" @submit.prevent="search"><Icon name="search" :size="17" /><input v-model="keyword" maxlength="100" placeholder="搜索游戏 / 道具" aria-label="搜索游戏或道具" /><kbd>↵</kbd></form>
    <RouterLink to="/cart" class="header-cart" aria-label="购物车"><Icon name="cart" :size="22" /><span v-if="cart.count" class="cart-count">{{ cart.count > 99 ? '99+' : cart.count }}</span></RouterLink>
    <div v-if="auth.loggedIn" class="account-menu"><button class="avatar-button" :aria-expanded="menu" @click="menu = !menu">{{ (auth.member?.nickname || '玩').slice(0, 1) }}</button><div v-if="menu" class="account-popover"><strong>{{ auth.member.nickname }}</strong><RouterLink to="/me/orders">我的订单</RouterLink><RouterLink to="/me/profile">玩家中心</RouterLink><button @click="logout">退出登录</button></div></div>
    <RouterLink v-else to="/login" class="btn login-link">登录 / 注册<Icon name="arrow" :size="16" /></RouterLink>
  </div><nav class="mobile-nav container" aria-label="移动端导航">
    <RouterLink v-for="item in mobileNavigation" :key="item.key" :to="item.to" custom v-slot="{ href, navigate }">
      <a :href="href" :class="{ active: activeNavigation === item.key }" :aria-current="activeNavigation === item.key ? 'page' : undefined" @click="navigate">{{ item.label }}</a>
    </RouterLink>
  </nav></header>
  <main id="main-content" class="main-content"><RouterView :key="route.name === 'account' ? route.params.section : route.name === 'prop' ? route.params.propId : route.name === 'order' || route.name === 'pay' ? route.params.orderNo : route.name" /></main>
  <footer class="site-footer"><div class="container footer-top"><RouterLink to="/" class="brand footer-brand"><BrandLogo /></RouterLink><div class="footer-links"><RouterLink to="/props">探索道具</RouterLink><RouterLink to="/me/orders">我的订单</RouterLink><RouterLink to="/me/profile">玩家中心</RouterLink></div><DemoTools v-if="DemoTools" /><span class="footer-note"><Icon name="game" :size="17" /> 发现好装备，开启新冒险</span></div><div class="container footer-bottom"><span>© 2026 gameshop</span><span>游戏道具 · 装备精选 · 为热爱而来</span></div></footer>
  </div>
</template>
