<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElPagination } from 'element-plus'
import { catalogApi } from '../api/mall.js'
import { useRequest } from '../composables/useRequest.js'
import { useAuthStore } from '../stores/auth.js'
import { useCartStore } from '../stores/cart.js'
import { useCheckoutStore } from '../stores/checkout.js'
import { money, dateOnly } from '../utils/format.js'
import Icon from '../components/Icon.vue'
import ItemArt from '../components/ItemArt.vue'
import QuantityInput from '../components/QuantityInput.vue'
import StatePanel from '../components/StatePanel.vue'
import SafeRichText from '../components/SafeRichText.vue'
const route = useRoute(), router = useRouter(), auth = useAuthStore(), cart = useCartStore(), checkout = useCheckoutStore()
const quantity = ref(1), busy = ref(false), selectedImage = ref(0), tab = ref('detail'), reviewPage = ref(1)
const { data: product, error, loading, load } = useRequest(async () => (await catalogApi.prop(route.params.propId)).data)
const { data: reviews, error: reviewError, loading: reviewsLoading, load: loadReviews } = useRequest(() => catalogApi.reviews(route.params.propId, { pageNum: reviewPage.value, pageSize: 10 }))
const max = computed(() => Math.max(1, Math.min(product.value?.stock || 1, 99)))
async function purchase(direct) {
  if (!auth.loggedIn) return router.push({ name: 'login', query: { redirect: route.fullPath } })
  if (direct) { checkout.begin({ source: 'DIRECT', items: [{ propId: product.value.propId, quantity: quantity.value }] }); return router.push('/checkout') }
  busy.value = true
  try { await cart.add({ propId: product.value.propId, quantity: quantity.value }); ElMessage.success('道具已加入购物车') } catch (e) { ElMessage.error(e.uncertain ? '加购结果尚未确认，请先到购物车核对数量。' : e.message) } finally { busy.value = false }
}
function refresh() { load(); loadReviews() }
onMounted(() => { refresh(); window.addEventListener('mall-demo-change', refresh) }); onUnmounted(() => window.removeEventListener('mall-demo-change', refresh))
</script>
<template><div class="container page-view"><nav class="breadcrumbs"><RouterLink to="/">首页</RouterLink><Icon name="chevron" :size="13" /><RouterLink to="/props">全部道具</RouterLink><Icon name="chevron" :size="13" /><span>{{ product?.name || '道具详情' }}</span></nav><StatePanel :loading="loading" :error="error" @retry="load"><template v-if="product">
  <div class="product-detail"><div class="product-gallery"><ItemArt class="detail-art" :src="product.images[selectedImage]?.url || product.coverUrl" :alt="product.name" /><div v-if="product.images.length > 1" class="thumbnails"><button v-for="(img, i) in product.images" :key="img.url" :class="{ active: selectedImage === i }" :aria-label="`查看第 ${i + 1} 张图片`" @click="selectedImage = i"><ItemArt :src="img.url" :alt="product.name" /></button></div><p class="gallery-caption"><Icon name="eye" :size="15" />道具展示图 · 具体内容以商品说明为准</p></div><div class="product-description"><RouterLink :to="{ name: 'catalog', query: { categoryId: product.categoryId } }" class="category-tag"><Icon name="game" :size="15" />{{ product.categoryName }}</RouterLink><h1>{{ product.name }}</h1><div class="detail-reputation"><span class="stars">★★★★★</span><span>{{ product.averageScore.toFixed(1) }} 分</span><span class="divider">|</span><button class="text-button" @click="tab = 'reviews'">{{ product.reviewCount }} 条评价</button><span class="divider">|</span><span>已售 {{ product.sales }} 件</span></div><div class="detail-price"><span class="price"><small>¥</small>{{ money(product.price) }}</span><del v-if="product.originalPrice">¥{{ money(product.originalPrice) }}</del><span v-if="product.originalPrice && product.price !== product.originalPrice" class="tag mint">精选好价</span></div><dl class="spec-list"><div v-for="spec in product.specs" :key="spec.name"><dt>{{ spec.name }}</dt><dd>{{ spec.value }}</dd></div></dl><div class="purchase-quantity"><span>购买数量</span><QuantityInput v-model="quantity" :max="max" :disabled="!product.canPurchase" /><span class="stock-label" :class="{ danger: !product.canPurchase }">{{ product.canPurchase ? `库存 ${product.stock} 件` : '暂时缺货' }}</span><button class="icon-button" aria-label="刷新库存" @click="load"><Icon name="refresh" :size="15" /></button></div><div class="purchase-actions"><button class="btn" :disabled="!product.canPurchase || busy" @click="purchase(true)">立即购买<Icon name="arrow" :size="18" /></button><button class="btn secondary" :disabled="!product.canPurchase || busy" @click="purchase(false)"><Icon name="cart" :size="18" />{{ busy ? '加入中…' : '加入购物车' }}</button></div><div class="delivery-note"><Icon name="shield" :size="19" /><p>下单时填写准确的游戏账号、区服和角色名，<br />付款后即可在订单详情跟踪道具交付进度。</p></div></div></div>
  <section class="detail-lower"><div class="tabs"><button :class="{ active: tab === 'detail' }" @click="tab = 'detail'">道具详情</button><button :class="{ active: tab === 'reviews' }" @click="tab = 'reviews'">玩家评价 <span>{{ product.reviewCount }}</span></button><button :class="{ active: tab === 'delivery' }" @click="tab = 'delivery'">购买须知</button></div><SafeRichText v-if="tab === 'detail'" :html="product.detailHtml" /><div v-else-if="tab === 'delivery'" class="rich-text"><h2>交付前，请确认这些信息</h2><p>请确认商品适用游戏，并准确填写账号、区服和角色名。我们不会要求你的游戏密码。</p><p>订单支付后将安排道具交付，交付完成后即可分享你的使用体验。</p><p>待支付订单的支付期限以订单倒计时为准；若不再需要，可在订单详情中取消。</p></div><div v-else><StatePanel :loading="reviewsLoading" :error="reviewError" :empty="reviews?.rows.length === 0" title="还没有玩家评价" description="已完成订单的玩家可以分享自己的体验。" @retry="loadReviews"><template #action><span /></template><article v-for="review in reviews?.rows" :key="review.reviewId" class="review-row"><span class="review-avatar">{{ review.reviewer.displayName.slice(0, 1) }}</span><div><strong>{{ review.reviewer.displayName }}</strong><div class="stars">{{ '★'.repeat(review.score) }}<span class="muted">{{ '★'.repeat(5 - review.score) }}</span></div><p>{{ review.content }}</p><time>{{ dateOnly(review.createdAt) }}</time></div></article></StatePanel><ElPagination v-if="reviews?.total > 10" layout="prev, pager, next" :total="reviews.total" :current-page="reviewPage" @current-change="reviewPage = $event; loadReviews()" /></div></section>
</template></StatePanel></div></template>
