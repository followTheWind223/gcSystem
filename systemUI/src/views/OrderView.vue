<script setup>
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessageBox } from 'element-plus'
import { orderApi } from '../api/mall.js'
import { useClock } from '../composables/useClock.js'
import { money, dateTime, statusText, deliveryLabels, deliveryServerText } from '../utils/format.js'
import Icon from '../components/Icon.vue'
import ItemArt from '../components/ItemArt.vue'
import StatePanel from '../components/StatePanel.vue'
import ReviewDialog from '../components/ReviewDialog.vue'
const route = useRoute(), clock = useClock(), order = ref(null), loading = ref(true), error = ref(null), actionError = ref(''), busy = ref(false), outcome = ref(''), reviewItem = ref(null), refreshError = ref('')
const isPay = computed(() => route.name === 'pay'), remaining = computed(() => clock.remaining(order.value?.expiresAt))
let timer, inFlight = false
async function load(quiet = false) {
  if (inFlight) return
  inFlight = true
  if (!quiet) { loading.value = true; error.value = null }
  try { const data = (await orderApi.detail(route.params.orderNo)).data; order.value = data; clock.sync(data.serverTime); refreshError.value = ''; error.value = null }
  catch (e) { if (!quiet || !order.value) error.value = e; else refreshError.value = '最新订单状态同步失败，请刷新后继续操作。' }
  finally { loading.value = false; inFlight = false }
}
async function pay(result) {
  busy.value = true; actionError.value = ''; outcome.value = ''
  try { const { data } = await orderApi.pay(order.value.orderNo, result); order.value = data.order; clock.sync(data.order.serverTime); outcome.value = data.outcome }
  catch (e) { actionError.value = e.message; await load(true) }
  finally { busy.value = false }
}
async function cancel() {
  try { await ElMessageBox.confirm('取消后将释放已预留的道具库存。确定取消这笔订单？', '取消订单', { confirmButtonText: '取消订单', cancelButtonText: '保留订单', type: 'warning' }) } catch { return }
  busy.value = true; actionError.value = ''
  try { order.value = (await orderApi.cancel(order.value.orderNo, { reason: '会员主动取消订单' })).data; clock.sync(order.value.serverTime) } catch (e) { actionError.value = e.message; await load(true) } finally { busy.value = false }
}
function visibility() { if (!document.hidden) load(true) }
function refresh() { load(true) }
watch(remaining, (n, old) => { if (old > 0 && n === 0 && order.value?.status === '1') load(true) })
onMounted(() => { load(); timer = setInterval(() => { if (!document.hidden && !busy.value) load(true) }, 15000); document.addEventListener('visibilitychange', visibility); window.addEventListener('mall-demo-change', refresh) })
onUnmounted(() => { clearInterval(timer); document.removeEventListener('visibilitychange', visibility); window.removeEventListener('mall-demo-change', refresh) })
</script>
<template><div class="container page-view"><nav class="breadcrumbs"><RouterLink to="/me/orders">我的订单</RouterLink><Icon name="chevron" :size="13" /><span>{{ isPay ? '订单支付' : '订单详情' }}</span></nav><StatePanel :loading="loading" :error="error" @retry="load()"><template v-if="order"><section class="order-status-banner" :class="`status-${order.status}`"><div class="order-status-icon"><Icon :name="{ '1': 'clock', '2': 'check', '3': 'close', '4': 'box' }[order.status]" :size="34" /></div><div><span class="eyebrow">ORDER STATUS</span><h1>{{ order.status === '1' && !remaining ? '支付时间已结束' : statusText[order.status] }}</h1><p>{{ order.status === '1' ? remaining ? '装备已为你预留，请在有效期内完成支付。' : '订单正在等待关闭，请以刷新后的订单状态为准。' : order.status === '2' ? '支付已完成，我们将核对游戏信息并安排道具交付。' : order.status === '4' ? '道具已交付，祝你的下一场冒险顺利！' : '订单已取消，欢迎继续探索其他装备。' }}</p></div><div v-if="order.status === '1' && remaining" class="order-countdown"><span>剩余支付时间</span><strong>{{ clock.display(remaining) }}</strong></div><RouterLink v-else to="/props" class="btn secondary">继续探索<Icon name="arrow" :size="16" /></RouterLink></section>
  <p v-if="refreshError" class="notice warning" role="alert">{{ refreshError }}<button class="text-button" @click="load(true)">刷新状态</button></p><p v-if="actionError" class="notice warning" role="alert">{{ actionError }}</p><p v-if="outcome === 'FAILED'" class="notice warning" role="status">支付失败，订单仍待支付，可以在有效期内重新尝试。</p><p v-if="outcome === 'SUCCESS'" class="notice success" role="status"><Icon name="check" />支付成功。</p>
  <div class="order-content-grid"><div><section class="panel"><div class="panel-heading"><h2>订单信息</h2><button class="text-button" @click="load(true)"><Icon name="refresh" :size="15" />刷新状态</button></div><dl class="order-facts"><div><dt>订单编号</dt><dd>{{ order.orderNo }}</dd></div><div><dt>创建时间</dt><dd>{{ dateTime(order.createdAt) }}</dd></div><div v-if="order.paidAt"><dt>支付时间</dt><dd>{{ dateTime(order.paidAt) }}</dd></div><div v-if="order.cancelledAt"><dt>取消时间</dt><dd>{{ dateTime(order.cancelledAt) }}</dd></div><div v-if="order.cancelReason"><dt>取消原因</dt><dd>{{ order.cancelReason }}</dd></div><div v-if="order.remark"><dt>订单备注</dt><dd>{{ order.remark }}</dd></div></dl></section><section class="panel"><h2 class="panel-title">道具清单</h2><article v-for="item in order.items" :key="item.orderItemId" class="checkout-item"><ItemArt :src="item.coverUrl" :alt="item.propName" /><div><RouterLink :to="`/props/${item.propId}`"><strong>{{ item.propName }}</strong></RouterLink><p>{{ item.specs.map(s => `${s.name}：${s.value}`).join(' · ') }}</p><small>¥{{ money(item.unitPrice) }} × {{ item.quantity }}</small><button v-if="item.canReview" class="text-button accent" @click="reviewItem = item">评价道具<Icon name="star" :size="14" /></button><span v-else-if="item.reviewId" class="tag">已评价</span></div><strong>¥{{ money(item.subtotal) }}</strong></article></section><section class="panel"><h2 class="panel-title">交付信息</h2><dl class="order-facts"><div v-for="(label, key) in deliveryLabels" :key="key"><template v-if="order.deliveryInfo[key] || (key === 'serverName' && order.deliveryInfo.servers?.length)"><dt>{{ label }}</dt><dd>{{ key === 'serverName' ? deliveryServerText(order.deliveryInfo) : order.deliveryInfo[key] }}</dd></template></div></dl><div v-if="order.delivery" class="delivery-result"><span class="tag mint">已交付</span><p>{{ order.delivery.note }}</p><small>{{ dateTime(order.delivery.deliveredAt) }}</small></div><p v-else class="muted">{{ order.status === '2' ? '正在核对游戏信息，请耐心等待道具交付。' : '交付记录将在道具交付后展示。' }}</p></section><section class="panel"><h2 class="panel-title">订单进度</h2><ol class="order-timeline"><li v-for="(log, i) in order.logs" :key="i"><span class="timeline-dot" /><div><strong>{{ log.reason === '模拟支付成功' ? '支付成功' : log.reason }}</strong><time>{{ dateTime(log.createdAt) }}</time></div></li></ol></section></div><aside class="panel order-summary"><h2>{{ isPay ? '支付订单' : '订单金额' }}</h2><dl><div><dt>道具数量</dt><dd>{{ order.totalQuantity }} 件</dd></div></dl><div class="checkout-total"><span>订单总额</span><strong><small>¥</small>{{ money(order.totalAmount) }}</strong></div><template v-if="order.canPay && remaining"><button v-if="isPay" class="btn full" :disabled="busy || !!refreshError" @click="pay('SUCCESS')">{{ busy ? '处理中…' : '去支付' }}<Icon name="arrow" :size="16" /></button><RouterLink v-else :to="`/orders/${order.orderNo}/pay`" class="btn full">去支付<Icon name="arrow" :size="16" /></RouterLink></template><button v-if="order.canCancel" class="text-button cancel-order" :disabled="busy || !!refreshError" @click="cancel">取消订单</button><RouterLink to="/me/orders" class="text-button">查看全部订单</RouterLink></aside></div>
</template></StatePanel><ReviewDialog :item="reviewItem" @close="reviewItem = null" @submitted="load(true)" /></div></template>
