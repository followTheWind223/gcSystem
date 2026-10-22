<script setup>
import { ref, reactive, computed, onMounted, onUnmounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElPagination } from 'element-plus'
import { memberApi, orderApi } from '../api/mall.js'
import { useAuthStore } from '../stores/auth.js'
import { useCartStore } from '../stores/cart.js'
import { useCheckoutStore } from '../stores/checkout.js'
import { money, dateTime, dateOnly, statusText, validPassword, mediaUrl } from '../utils/format.js'
import Icon from '../components/Icon.vue'
import ItemArt from '../components/ItemArt.vue'
import StatePanel from '../components/StatePanel.vue'
const auth = useAuthStore(), cart = useCartStore(), checkout = useCheckoutStore(), route = useRoute(), router = useRouter()
const section = computed(() => route.params.section), data = ref(null), loading = ref(true), error = ref(null), busy = ref(false), formError = ref('')
const pageNum = computed(() => Math.min(100000, Math.max(1, Math.trunc(Number(route.query.pageNum)) || 1))), status = computed(() => ['1', '2', '3', '4'].includes(route.query.status) ? route.query.status : '')
const form = reactive({ nickname: '', phoneNumber: '', oldPassword: '', newPassword: '', confirm: '' })
const tabs = [['', '全部订单'], ['1', '待支付'], ['2', '待交付'], ['4', '已完成'], ['3', '已取消']]
const menu = [['profile', 'user', '个人资料'], ['orders', 'box', '我的订单'], ['reviews', 'star', '我的评价'], ['password', 'lock', '账号安全']]
const heading = computed(() => ({ profile: ['个人资料', '完善玩家档案，让冒险更有个性。'], orders: ['我的订单', '每一次装备升级，都在这里。'], reviews: ['我的评价', '记录你的装备体验，分享给更多玩家。'], password: ['账号安全', '定期更新密码，保护你的玩家账号。'] }[section.value]))
let sequence = 0
async function load() {
  const run = ++sequence; loading.value = true; error.value = null
  try {
    let result
    if (section.value === 'orders') result = await orderApi.list({ pageNum: pageNum.value, pageSize: 10, ...(status.value ? { status: status.value } : {}) })
    else if (section.value === 'reviews') result = await memberApi.reviews({ pageNum: pageNum.value, pageSize: 10 })
    else { const response = await memberApi.profile(); result = response.data; if (run === sequence) { auth.member = result; form.nickname = result.nickname; form.phoneNumber = result.phoneNumber || '' } }
    if (run === sequence) data.value = result
  } catch (e) { if (run === sequence) error.value = e } finally { if (run === sequence) loading.value = false }
}
function updateQuery(patch) { router.push({ path: route.path, query: { ...route.query, pageNum: undefined, ...patch } }) }
async function save() {
  busy.value = true; formError.value = ''
  try {
    if (section.value === 'profile') {
      const nickname = form.nickname.trim(), phone = form.phoneNumber.trim()
      if (nickname.length < 2 || nickname.length > 30) throw new Error('昵称需要 2–30 个字符。')
      if (phone && !/^\+?[0-9 -]{7,20}$/.test(phone)) throw new Error('请输入有效的联系电话。')
      const result = await memberApi.update({ nickname, phoneNumber: phone || null }); auth.member = result.data; ElMessage.success('个人资料已更新')
    } else {
      if (!validPassword(form.newPassword)) throw new Error('新密码需为 8–64 位，包含字母和数字，不含空格或中文。')
      if (form.newPassword !== form.confirm) throw new Error('两次输入的新密码不一致。')
      await memberApi.password({ oldPassword: form.oldPassword, newPassword: form.newPassword }); auth.clear(); cart.clear(); checkout.clear(); form.oldPassword = ''; form.newPassword = ''; form.confirm = ''; ElMessage.success('密码已更新，请重新登录'); router.replace('/login')
    }
  } catch (e) { formError.value = e.message } finally { busy.value = false }
}
async function upload(event) {
  const file = event.target.files[0]; event.target.value = ''; if (!file) return
  busy.value = true; formError.value = ''
  try {
    if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type) || !/\.(jpe?g|png|webp)$/i.test(file.name) || file.size > 2097152) throw new Error('请选择 2MB 以内的 JPG、PNG 或 WebP 图片。')
    const bitmap = await createImageBitmap(file)
    const oversized = bitmap.width > 4096 || bitmap.height > 4096; bitmap.close()
    if (oversized) throw new Error('图片宽高不能超过 4096 像素。')
    auth.member = (await memberApi.avatar(file)).data; ElMessage.success('头像已更新')
  } catch (e) { formError.value = e.message || '图片无法读取，请重新选择。' } finally { busy.value = false }
}
watch(() => route.query, load)
onMounted(() => { load(); window.addEventListener('mall-demo-change', load) }); onUnmounted(() => { sequence++; window.removeEventListener('mall-demo-change', load) })
</script>
<template><div class="container page-view account-layout"><aside class="account-sidebar"><div class="account-identity"><img v-if="mediaUrl(auth.member?.avatarUrl)" :src="mediaUrl(auth.member.avatarUrl)" alt="我的头像" /><span v-else class="profile-avatar">{{ (auth.member?.nickname || '玩').slice(0, 1) }}</span><h3>{{ auth.member?.nickname }}</h3><span class="tag mint">商城会员</span></div><nav aria-label="玩家中心导航"><RouterLink v-for="[name, icon, label] in menu" :key="name" :to="`/me/${name}`" :class="{ active: section === name }"><Icon :name="icon" :size="19" />{{ label }}<Icon name="chevron" :size="14" /></RouterLink></nav><div class="sidebar-help"><Icon name="shield" :size="24" /><p>你的每一份热爱<br />都值得被认真对待。</p></div></aside><div class="account-main"><div class="page-heading compact"><span class="eyebrow">PLAYER CENTER</span><h1>{{ heading[0] }}<span class="heading-dot">.</span></h1><p>{{ heading[1] }}</p></div><div v-if="section === 'orders'" class="tabs order-tabs"><button v-for="[value, label] in tabs" :key="value" :class="{ active: status === value }" @click="updateQuery({ status: value || undefined })">{{ label }}</button></div>
  <StatePanel :loading="loading" :error="error" :empty="['orders', 'reviews'].includes(section) && data?.rows.length === 0" :title="section === 'orders' ? '这里还没有订单' : '还没有发表过评价'" :description="section === 'orders' ? '去商城探索，发现你的下一件装备。' : '完成订单后，就可以为购买的道具留下评价。'" @retry="load"><template #action><RouterLink :to="section === 'reviews' ? '/me/orders?status=4' : '/props'" class="btn secondary">{{ section === 'reviews' ? '查看已完成订单' : '去探索道具' }}</RouterLink></template>
    <template v-if="section === 'orders'"><article v-for="order in data?.rows" :key="order.orderNo" class="order-card"><header><span>订单编号 <strong>{{ order.orderNo }}</strong></span><span class="order-status" :class="`status-text-${order.status}`">{{ statusText[order.status] }}</span></header><div v-for="item in order.items" :key="item.orderItemId" class="order-card-item"><ItemArt :src="item.coverUrl" :alt="item.propName" /><div><RouterLink :to="`/props/${item.propId}`"><strong>{{ item.propName }}</strong></RouterLink><small>{{ item.specs.map(s => s.value).join(' · ') }}</small></div><span>¥{{ money(item.unitPrice) }}</span><span class="muted">× {{ item.quantity }}</span></div><footer><time>{{ dateTime(order.createdAt) }}</time><span>合计 <strong>¥{{ money(order.totalAmount) }}</strong></span><RouterLink :to="`/orders/${order.orderNo}`" class="btn secondary small">订单详情</RouterLink><RouterLink v-if="order.canPay" :to="`/orders/${order.orderNo}/pay`" class="btn small">去支付</RouterLink><RouterLink v-else-if="order.items.some(i => i.canReview)" :to="`/orders/${order.orderNo}`" class="btn small">去评价</RouterLink></footer></article></template>
    <template v-else-if="section === 'reviews'"><article v-for="review in data?.rows" :key="review.reviewId" class="my-review panel"><div class="my-review-product"><ItemArt :src="review.coverUrl" :alt="review.propName" /><div><RouterLink :to="`/props/${review.propId}`"><strong>{{ review.propName }}</strong></RouterLink><div class="stars">{{ '★'.repeat(review.score) }}<span class="muted">{{ '★'.repeat(5 - review.score) }}</span></div></div><span class="tag" :class="{ mint: review.status === 'VISIBLE' }">{{ review.status === 'VISIBLE' ? '公开展示' : '已隐藏' }}</span></div><p>{{ review.content }}</p><p v-if="review.status === 'HIDDEN'" class="notice warning">隐藏原因：{{ review.hideReason }}。该明细已评价，不可重复发布。</p><div class="review-foot"><time>{{ dateOnly(review.createdAt) }}</time><RouterLink :to="`/orders/${review.orderNo}`">查看关联订单 →</RouterLink></div></article></template>
    <form v-else-if="section === 'profile'" class="panel profile-form" @submit.prevent="save"><div class="avatar-upload"><img v-if="mediaUrl(auth.member?.avatarUrl)" :src="mediaUrl(auth.member.avatarUrl)" alt="我的头像" /><span v-else class="profile-avatar">{{ (auth.member?.nickname || '玩').slice(0, 1) }}</span><div><label class="btn secondary small" :class="{ disabled: busy }">更换头像<input type="file" accept="image/png,image/jpeg,image/webp" :disabled="busy" class="visually-hidden" @change="upload" /></label><small>JPG / PNG / WebP，最大 2MB</small></div></div><label class="field">用户名<input :value="auth.member?.username" disabled /><small class="muted">账号创建后不可修改</small></label><label class="field">玩家昵称<input v-model="form.nickname" minlength="2" maxlength="30" required /></label><label class="field">邮箱地址<input :value="auth.member?.email" disabled /></label><label class="field">联系电话<span class="optional">选填</span><input v-model="form.phoneNumber" type="tel" maxlength="20" placeholder="仅作为联系方式" /></label><p v-if="formError" class="form-error" role="alert">{{ formError }}</p><button class="btn" :disabled="busy">{{ busy ? '保存中…' : '保存修改' }}<Icon name="check" :size="17" /></button></form>
    <form v-else class="panel profile-form" @submit.prevent="save"><p class="notice"><Icon name="lock" />修改成功后，所有登录会话将失效，需要重新登录。</p><label class="field">当前密码<input v-model="form.oldPassword" type="password" autocomplete="current-password" maxlength="64" required placeholder="请输入当前密码" /></label><label class="field">新密码<input v-model="form.newPassword" type="password" autocomplete="new-password" minlength="8" maxlength="64" required placeholder="8–64 位，包含字母和数字" /></label><label class="field">确认新密码<input v-model="form.confirm" type="password" autocomplete="new-password" minlength="8" maxlength="64" required placeholder="再次输入新密码" /></label><p v-if="formError" class="form-error" role="alert">{{ formError }}</p><button class="btn" :disabled="busy">{{ busy ? '更新中…' : '更新密码' }}<Icon name="arrow" :size="17" /></button></form>
  </StatePanel><ElPagination v-if="['orders', 'reviews'].includes(section) && data?.total > 10" background layout="prev, pager, next" :total="data.total" :current-page="pageNum" @current-change="updateQuery({ pageNum: String($event) })" /></div></div></template>
