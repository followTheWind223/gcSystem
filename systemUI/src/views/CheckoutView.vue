<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useCheckoutStore } from '../stores/checkout.js'
import { useCartStore } from '../stores/cart.js'
import { orderApi } from '../api/mall.js'
import { useClock } from '../composables/useClock.js'
import { money, deliveryLabels } from '../utils/format.js'
import Icon from '../components/Icon.vue'
import ItemArt from '../components/ItemArt.vue'
import StatePanel from '../components/StatePanel.vue'
import ShopSelect from '../components/ShopSelect.vue'
const store = useCheckoutStore(), cart = useCartStore(), router = useRouter(), clock = useClock()
const quote = ref(null), loading = ref(false), error = ref(null), submitError = ref(null), busy = ref(false), agreed = ref(false), uncertain = ref(Boolean(store.payload)), remark = ref(''), delivery = reactive({ gameAccount: '', serverName: '', roleName: '' })
const serverChoices = reactive({})
const serverGroups = computed(() => quote.value?.serverGroups || [])
const needsServers = computed(() => quote.value?.deliveryFields.includes('serverName'))
const missingServers = computed(() => needsServers.value && (!serverGroups.value.length || serverGroups.value.some(group => !group.servers.length)))
const serversReady = computed(() => !needsServers.value || (!missingServers.value && serverGroups.value.every(group => group.servers.some(server => server.serverId === serverChoices[group.categoryId]))))
const remaining = computed(() => clock.remaining(quote.value?.quoteExpiresAt)), conflict = computed(() => submitError.value?.status === 409)
async function preview() {
  if (!store.source || uncertain.value) return
  loading.value = true; error.value = null; submitError.value = null; agreed.value = false; store.payload = null
  try { quote.value = (await orderApi.preview(store.source)).data; clock.sync(quote.value.serverTime); for (const key of Object.keys(serverChoices)) if (!serverGroups.value.some(group => group.categoryId === key && group.servers.some(server => server.serverId === serverChoices[key]))) delete serverChoices[key] } catch (e) { error.value = e } finally { loading.value = false }
}
async function submit() {
  if (busy.value) return
  submitError.value = null; busy.value = true
  try {
    if (!store.payload) {
      if (!agreed.value || !remaining.value) throw new Error('请确认有效报价后再提交订单。')
      const info = {}
      for (const field of quote.value.deliveryFields.filter(field => field !== 'serverName')) { if (!delivery[field]?.trim()) throw new Error(`请填写${deliveryLabels[field]}`); info[field] = delivery[field].trim() }
      if (needsServers.value) { if (!serversReady.value) throw new Error('请为每个游戏选择可用区服。'); info.serverIds = serverGroups.value.map(group => serverChoices[group.categoryId]) }
      store.payload = { quoteToken: quote.value.quoteToken, requestKey: crypto.randomUUID(), deliveryInfo: info, remark: remark.value.trim() || null }
    }
    const { data } = await orderApi.create(store.payload)
    store.clear(); await cart.load().catch(() => {}); await router.replace(`/orders/${data.order.orderNo}/pay`)
  } catch (e) { submitError.value = e; if (e.uncertain) uncertain.value = true; else if (e.status === 409) { store.payload = null; uncertain.value = false; agreed.value = false } else if (!uncertain.value) store.payload = null }
  finally { busy.value = false }
}
onMounted(preview)
</script>
<template><div class="container page-view"><div class="page-heading compact"><span class="eyebrow">ONE STEP CLOSER TO ADVENTURE</span><h1>确认订单<span class="heading-dot">.</span></h1><div class="checkout-steps"><span class="active">01 确认订单</span><i /><span>02 支付订单</span><i /><span>03 等待交付</span></div></div>
  <StatePanel v-if="!store.source" empty title="当前没有待确认的订单" description="如果刚刚提交过订单，请先在我的订单中核对，避免重复下单。"><template #action><RouterLink to="/me/orders" class="btn">查看我的订单</RouterLink><RouterLink to="/props" class="text-button">继续选购</RouterLink></template></StatePanel>
  <div v-else-if="uncertain" class="panel uncertain-panel"><Icon name="info" :size="32" /><h2>订单提交结果尚未确认</h2><p>网络中断，暂时无法确认订单是否提交成功。请先核对订单状态。</p><p class="muted">本次购买信息已保留，点击下方按钮可继续查询，不会重复下单。</p><p v-if="submitError" class="form-error" role="alert">{{ submitError.message }}</p><div class="button-row"><button class="btn" :disabled="busy" @click="submit">{{ busy ? '核对中…' : '查询订单结果' }}</button><RouterLink to="/me/orders" class="btn secondary">查看我的订单</RouterLink></div></div>
  <StatePanel v-else :loading="loading" :error="error" @retry="preview"><form v-if="quote" class="checkout-grid" @submit.prevent="submit"><div><section class="panel"><h2 class="panel-title"><Icon name="box" />道具清单</h2><article v-for="item in quote.items" :key="item.propId" class="checkout-item"><ItemArt :src="item.coverUrl" :alt="item.propName" /><div><strong>{{ item.propName }}</strong><p>{{ item.specs.map(s => `${s.name}：${s.value}`).join(' · ') }}</p><small>¥{{ money(item.unitPrice) }} × {{ item.quantity }}</small></div><strong>¥{{ money(item.subtotal) }}</strong></article></section><section class="panel"><h2 class="panel-title"><Icon name="game" />交付信息</h2><p class="muted">请核对游戏账号、区服和角色名称，确保道具准确交付。无需提供游戏密码。</p><div class="delivery-fields">
          <label v-for="field in quote.deliveryFields.filter(field => field !== 'serverName')" :key="field" class="field" :class="{ 'role-field': field === 'roleName' }">{{ deliveryLabels[field] }}<input v-model="delivery[field]" :name="field" :placeholder="`请输入${deliveryLabels[field]}`" maxlength="100" :disabled="busy" autocomplete="off" required /></label>
          <label v-for="group in serverGroups" :key="group.categoryId" class="field server-field">{{ serverGroups.length === 1 ? '游戏区服' : `游戏区服 · ${group.categoryName}` }}
            <ShopSelect v-model="serverChoices[group.categoryId]" :id="`server-${group.categoryId}`" :label="serverGroups.length === 1 ? '游戏区服' : `游戏区服 · ${group.categoryName}`" :placeholder="group.servers.length ? '请选择游戏区服' : '暂无可用区服'" :options="group.servers.map(server => ({ value: server.serverId, label: server.name }))" class="server-select" :disabled="busy || !group.servers.length" />
          </label>
        </div><p v-if="missingServers" class="form-error" role="status">当前游戏暂无可用区服，请刷新报价或稍后重试。</p><label class="field">订单备注<span class="optional">选填</span><textarea v-model="remark" rows="3" maxlength="200" :disabled="busy" placeholder="有需要说明的交付事项，可在这里留言" /><small class="text-right muted">{{ remark.length }} / 200</small></label></section></div><aside class="panel order-summary"><h2>订单汇总</h2><dl><div><dt>道具数量</dt><dd>{{ quote.totalQuantity }} 件</dd></div><div><dt>商品金额</dt><dd>¥{{ money(quote.totalAmount) }}</dd></div><div><dt>交付方式</dt><dd>虚拟道具交付</dd></div></dl><div class="checkout-total"><span>应付总额</span><strong><small>¥</small>{{ money(quote.totalAmount) }}</strong></div><p class="quote-time" :class="{ danger: !remaining }"><Icon name="clock" :size="16" />{{ remaining ? `当前报价有效期 ${clock.display(remaining)}` : '当前报价已到期' }}</p><button v-if="!remaining || conflict || missingServers" type="button" class="btn secondary full" :disabled="busy" @click="preview">重新获取报价</button><p v-if="submitError" class="form-error" role="alert">{{ submitError.message }}<span v-for="item in submitError.details?.items" :key="item.propId">道具 {{ item.propId }}：{{ item.reason }}，可用库存 {{ item.availableStock }}</span></p><label class="checkbox-label"><input v-model="agreed" type="checkbox" :disabled="busy || !remaining || conflict" />我已确认当前价格、数量及交付信息</label><button class="btn full" :disabled="busy || !agreed || !remaining || conflict || !serversReady">{{ busy ? '提交中…' : '提交订单' }}<Icon name="arrow" :size="17" /></button></aside></form></StatePanel>
</div></template>

<style scoped>.server-field{order:1}.role-field{order:2}.server-select{width:100%}.server-select :deep(.el-select__wrapper){min-height:44px;background:#111719}</style>
