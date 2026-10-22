import { createApp } from 'vue'
import { createPinia } from 'pinia'
import 'element-plus/dist/index.css'
import 'element-plus/theme-chalk/dark/css-vars.css'
import './styles.css'
import App from './App.vue'
import { router } from './router.js'
import { configureHttp } from './api/http.js'
import { useAuthStore } from './stores/auth.js'
import { useCartStore } from './stores/cart.js'
import { useCheckoutStore } from './stores/checkout.js'

const app = createApp(App)
app.use(createPinia())
configureHttp({
  getToken: () => useAuthStore().token,
  onUnauthorized: () => {
    useAuthStore().clear()
    useCartStore().clear()
    useCheckoutStore().clear()
    if (router.currentRoute.value.meta.auth) router.replace({ name: 'login', query: { redirect: router.currentRoute.value.fullPath } })
  },
})
app.use(router).mount('#app')
