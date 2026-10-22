import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from './stores/auth.js'
export const router = createRouter({
  history: createWebHistory(),
  scrollBehavior(to, from, saved) { return saved || (to.path === from.path ? undefined : { top: 0 }) },
  routes: [
    { path: '/', name: 'home', component: () => import('./views/HomeView.vue'), meta: { title: '探索商城' } },
    { path: '/props', name: 'catalog', component: () => import('./views/CatalogView.vue'), meta: { title: '全部道具' } },
    { path: '/props/:propId', name: 'prop', component: () => import('./views/ProductView.vue'), meta: { title: '道具详情' } },
    ...['login', 'register', 'forgot-password'].map(name => ({ path: `/${name}`, name, component: () => import('./views/AuthView.vue'), meta: { layout: 'auth', title: { login: '会员登录', register: '注册账号', 'forgot-password': '找回密码' }[name] } })),
    { path: '/cart', name: 'cart', component: () => import('./views/CartView.vue'), meta: { auth: true, title: '购物车' } },
    { path: '/checkout', name: 'checkout', component: () => import('./views/CheckoutView.vue'), meta: { auth: true, title: '确认订单' } },
    { path: '/orders/:orderNo/pay', name: 'pay', component: () => import('./views/OrderView.vue'), meta: { auth: true, title: '订单支付' } },
    { path: '/orders/:orderNo', name: 'order', component: () => import('./views/OrderView.vue'), meta: { auth: true, title: '订单详情' } },
    { path: '/me', redirect: '/me/profile' },
    { path: '/me/:section(profile|password|orders|reviews)', name: 'account', component: () => import('./views/AccountView.vue'), meta: { auth: true, title: '玩家中心' } },
    { path: '/:pathMatch(.*)*', name: 'not-found', component: () => import('./views/NotFoundView.vue'), meta: { title: '页面未找到' } },
  ],
})
router.beforeEach(to => {
  if (to.meta.auth && !useAuthStore().loggedIn) { useAuthStore().clear(); return { name: 'login', query: { redirect: to.fullPath } } }
})
router.afterEach(to => { document.title = `${to.meta.title} · gameshop` })
