<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useAuthStore } from '../stores/auth.js'
import { useCartStore } from '../stores/cart.js'
import { money } from '../utils/format.js'
import Icon from './Icon.vue'
import ItemArt from './ItemArt.vue'
const props = defineProps({ product: Object, index: { type: Number, default: 0 } })
const router = useRouter(), route = useRoute(), auth = useAuthStore(), cart = useCartStore(), busy = ref(false)
async function add() {
  if (!auth.loggedIn) return router.push({ name: 'login', query: { redirect: route.fullPath } })
  busy.value = true
  try { await cart.add({ propId: props.product.propId, quantity: 1 }); ElMessage.success('已加入购物车') }
  catch (e) { ElMessage.error(e.uncertain ? '加购结果尚未确认，已重新读取购物车，请先核对数量。' : e.message) }
  finally { busy.value = false }
}
</script>
<template>
  <article class="product-card">
    <RouterLink :to="`/props/${product.propId}`" class="product-visual" :aria-label="`查看${product.name}`">
      <ItemArt :src="product.coverUrl" :alt="product.name" />
      <span v-if="!product.canPurchase" class="product-tag sold-out">暂时缺货</span>
      <span v-else-if="product.originalPrice && product.originalPrice !== product.price" class="product-tag">精选好价</span>
      <span class="product-game">{{ product.categoryName }}</span>
    </RouterLink>
    <div class="product-info"><RouterLink class="product-name" :to="`/props/${product.propId}`">{{ product.name }}</RouterLink><p class="product-meta">虚拟道具 <span>·</span> 已售 {{ product.sales }} 件</p>
      <div class="product-bottom"><div class="price"><small>¥</small>{{ money(product.price) }}<del v-if="product.originalPrice && product.originalPrice !== product.price">¥{{ money(product.originalPrice) }}</del></div><button class="quick-add" :disabled="busy || !product.canPurchase" :aria-label="`将${product.name}加入购物车`" @click="add"><Icon :name="busy ? 'clock' : 'plus'" :size="19" /></button></div>
    </div>
  </article>
</template>
