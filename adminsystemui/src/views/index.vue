<template>
  <main class="shop-workbench">
    <header class="workbench-heading">
      <div>
        <div class="eyebrow">商城运营中心</div>
        <h1>{{ userStore.nickName || '管理员' }}，欢迎回来</h1>
        <p>关注订单交付，管理好每一件游戏道具。</p>
      </div>
      <div class="refresh-area">
        <span v-if="updatedAt">更新于 {{ updatedAt }}</span>
        <el-button :loading="loading" icon="Refresh" @click="refresh">刷新数据</el-button>
      </div>
    </header>
    <el-alert v-if="hasError" class="load-alert" title="部分数据加载失败，请点击刷新数据重试。" type="error" :closable="false" show-icon />
    <section v-if="visibleMetrics.length" class="metric-grid" aria-label="商城概况">
      <router-link v-for="metric in visibleMetrics" :key="metric.key" :to="metric.to" class="metric" :class="metric.tone">
        <div class="metric-heading"><span>{{ metric.label }}</span><svg-icon :icon-class="metric.icon" /></div>
        <strong :aria-label="metric.label + '数量'">{{ metric.loading ? '…' : metric.error ? '—' : formatCount(metric.total) }}</strong>
        <div class="metric-hint">{{ metric.error ? '加载失败，等待重试' : metric.hint }}<span aria-hidden="true">→</span></div>
      </router-link>
    </section>
    <div class="workbench-body">
      <section v-if="canListOrders" class="panel order-panel" aria-labelledby="delivery-heading">
        <div class="panel-heading">
          <div><h2 id="delivery-heading">待交付订单</h2><p>已支付、等待登记道具交付的订单</p></div>
          <router-link class="text-link" :to="orderLink('2')">全部订单 →</router-link>
        </div>
        <div v-if="metrics.delivery.error" class="section-error" role="alert">
          <p>订单加载失败</p><el-button @click="refresh">重新加载</el-button>
        </div>
        <el-table v-else v-loading="metrics.delivery.loading" :data="deliveryOrders" row-key="orderId">
          <el-table-column prop="orderNo" label="订单号" min-width="190" show-overflow-tooltip />
          <el-table-column label="购买会员" min-width="120" show-overflow-tooltip>
            <template #default="{ row }">{{ row.member?.username || '—' }}</template>
          </el-table-column>
          <el-table-column label="订单金额" min-width="110">
            <template #default="{ row }"><span class="order-amount">¥{{ row.totalAmount }}</span></template>
          </el-table-column>
          <el-table-column label="下单时间" min-width="165">
            <template #default="{ row }">{{ formatDate(row.createdAt) }}</template>
          </el-table-column>
          <el-table-column label="操作" width="100" fixed="right">
            <template #default="{ row }"><router-link class="text-link" :to="{ path: '/gameshop/orders', query: { status: '2', orderNo: row.orderNo } }">去处理</router-link></template>
          </el-table-column>
          <template #empty><el-empty :image-size="70" description="暂无待交付订单" /></template>
        </el-table>
        <div class="table-note">显示最近 6 笔待交付订单</div>
      </section>
      <section v-else class="panel access-panel">
        <el-empty description="当前账号暂无订单查看权限，请从快捷入口进入已授权的功能。" :image-size="100" />
      </section>
      <aside class="workbench-aside">
        <section class="panel" aria-labelledby="quick-heading">
          <div class="panel-heading"><h2 id="quick-heading">快捷入口</h2></div>
          <div v-if="shortcuts.length" class="shortcut-grid">
            <router-link v-for="item in shortcuts" :key="item.path" :to="item.path" class="shortcut">
              <svg-icon :icon-class="item.icon" /><span>{{ item.label }}</span>
            </router-link>
          </div>
          <el-empty v-else description="暂无商城功能权限" :image-size="65" />
        </section>
        <section class="panel operation-note">
          <div class="panel-heading"><h2>运营提示</h2><svg-icon icon-class="message" /></div>
          <ul>
            <li>上架前检查商品价格、可售库存和交付说明。</li>
            <li>已支付订单请及时交付，填写交付记录后完成订单。</li>
            <li>库存变动可在库存流水中追踪，违规评价请填写隐藏原因。</li>
          </ul>
        </section>
      </aside>
    </div>
  </main>
</template>

<script setup name="Index">
import { computed, onMounted, reactive, ref } from 'vue'
import { listShop } from '@/api/gameshop'
import auth from '@/plugins/auth'
import useUserStore from '@/store/modules/user'

const userStore = useUserStore()
const loading = ref(false)
const updatedAt = ref('')
const deliveryOrders = ref([])
const orderLink = status => ({ path: '/gameshop/orders', query: { status } })
const metrics = reactive({
  props: { key: 'props', label: '在售商品', icon: 'shopping', tone: 'blue', hint: '查看已上架道具', resource: 'props', permission: 'mall:prop:list', params: { status: '1' }, to: { path: '/gameshop/props', query: { status: '1' } }, total: null, loading: true, error: false },
  delivery: { key: 'delivery', label: '待交付订单', icon: 'list', tone: 'amber', hint: '及时完成道具交付', resource: 'orders', permission: 'mall:order:list', params: { status: '2', pageSize: 6 }, to: orderLink('2'), total: null, loading: true, error: false },
  pending: { key: 'pending', label: '待支付订单', icon: 'time', tone: 'teal', hint: '查看待支付订单', resource: 'orders', permission: 'mall:order:list', params: { status: '1' }, to: orderLink('1'), total: null, loading: true, error: false },
  members: { key: 'members', label: '商城会员', icon: 'user', tone: 'slate', hint: '查看全部会员', resource: 'members', permission: 'mall:member:list', params: {}, to: '/gameshop/members', total: null, loading: true, error: false }
})
const visibleMetrics = computed(() => Object.values(metrics).filter(item => auth.hasPermi(item.permission)))
const hasError = computed(() => visibleMetrics.value.some(item => item.error))
const canListOrders = computed(() => auth.hasPermi('mall:order:list'))
const shortcuts = computed(() => [
  { label: '道具商品', path: '/gameshop/props', icon: 'shopping', permission: 'mall:prop:list' },
  { label: '商城订单', path: '/gameshop/orders', icon: 'list', permission: 'mall:order:list' },
  { label: '游戏分类', path: '/gameshop/categories', icon: 'tree', permission: 'mall:category:list' },
  { label: '游戏区服', path: '/gameshop/game-servers', icon: 'tree', permission: 'mall:server:list' },
  { label: '商城会员', path: '/gameshop/members', icon: 'user', permission: 'mall:member:list' },
  { label: '首页轮播', path: '/gameshop/banners', icon: 'list', permission: 'mall:banner:list' },
  { label: '商品评价', path: '/gameshop/reviews', icon: 'message', permission: 'mall:review:list' },
  { label: '库存流水', path: '/gameshop/stock-logs', icon: 'log', permission: 'mall:stock:list' }
].filter(item => auth.hasPermi(item.permission)))

const formatCount = value => value == null ? '—' : Number(value).toLocaleString('zh-CN')
const formatDate = value => value ? value.replace('T', ' ').replace('+08:00', '') : '—'

async function refresh() {
  if (loading.value) return
  loading.value = true
  try {
    await Promise.all(visibleMetrics.value.map(async metric => {
      metric.loading = true
      metric.error = false
      try {
        const response = await listShop(metric.resource, { pageNum: 1, pageSize: 1, ...metric.params })
        metric.total = response.total
        if (metric.key === 'delivery') deliveryOrders.value = response.rows
      } catch {
        metric.total = null
        metric.error = true
        if (metric.key === 'delivery') deliveryOrders.value = []
      } finally {
        metric.loading = false
      }
    }))
    updatedAt.value = new Date().toLocaleTimeString('zh-CN', { hour12: false })
  } finally {
    loading.value = false
  }
}

onMounted(refresh)
</script>

<style scoped>
.shop-workbench { min-height: calc(100vh - 84px); padding: 28px; background: var(--el-bg-color-page); color: var(--el-text-color-primary); }
.workbench-heading { display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 26px; }
.eyebrow { color: var(--el-color-primary); font-size: 12px; font-weight: 600; letter-spacing: 2px; margin-bottom: 10px; }
h1 { font-size: 24px; font-weight: 600; margin: 0 0 10px; }
.workbench-heading p, .panel-heading p { margin: 0; font-size: 13px; line-height: 1.6; color: var(--el-text-color-secondary); }
.refresh-area { display: flex; align-items: center; gap: 14px; flex-shrink: 0; }
.refresh-area > span { color: var(--el-text-color-secondary); font-size: 12px; }
.load-alert { margin-bottom: 18px; }
.metric-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 18px; margin-bottom: 24px; }
.metric { --metric-accent: #3877d5; background: var(--el-bg-color-overlay); border: 1px solid var(--el-border-color-lighter); border-top: 3px solid var(--metric-accent); border-radius: 8px; padding: 20px; transition: border-color .15s; }
.metric:hover { border-color: var(--metric-accent); }
.metric.amber { --metric-accent: #bb7b22; }.metric.teal { --metric-accent: #188578; }.metric.slate { --metric-accent: #697a92; }
.metric-heading { display: flex; justify-content: space-between; align-items: center; font-size: 14px; color: var(--el-text-color-regular); }
.metric-heading .svg-icon { color: var(--metric-accent); font-size: 21px; }
.metric strong { display: block; font-size: 34px; font-weight: 600; font-variant-numeric: tabular-nums; margin: 15px 0; }
.metric-hint { display: flex; justify-content: space-between; gap: 8px; font-size: 12px; color: var(--el-text-color-secondary); }
.workbench-body { display: grid; grid-template-columns: minmax(0, 1fr) 300px; gap: 24px; align-items: start; }
.panel { background: var(--el-bg-color-overlay); border: 1px solid var(--el-border-color-lighter); border-radius: 8px; overflow: hidden; }
.panel-heading { min-height: 68px; padding: 20px; display: flex; justify-content: space-between; align-items: center; gap: 12px; }
h2 { margin: 0; font-size: 16px; font-weight: 600; }.panel-heading p { margin-top: 6px; }
.text-link { color: var(--el-color-primary); font-size: 13px; white-space: nowrap; }.text-link:hover { text-decoration: underline; }
.order-panel :deep(.el-table th.el-table__cell) { background: var(--el-fill-color-light); }
.order-panel :deep(.el-table .cell) { padding-left: 20px; }
.order-amount { font-variant-numeric: tabular-nums; font-weight: 500; }
.table-note { padding: 14px 20px; color: var(--el-text-color-secondary); font-size: 12px; }
.section-error { text-align: center; padding: 48px 20px; color: var(--el-text-color-secondary); }
.workbench-aside { display: grid; gap: 20px; background: transparent; padding: 0; margin: 0; line-height: normal; color: inherit; }
.shortcut-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); padding: 0 12px 14px; }
.shortcut { display: flex; align-items: center; gap: 10px; border-radius: 6px; padding: 14px 10px; font-size: 13px; color: var(--el-text-color-regular); }
.shortcut .svg-icon { color: var(--el-color-primary); font-size: 17px; }.shortcut:hover { background: var(--el-fill-color-light); color: var(--el-color-primary); }
.operation-note .panel-heading { min-height: 60px; padding-bottom: 12px; }.operation-note .svg-icon { color: var(--el-text-color-secondary); }
.operation-note ul { padding: 0 22px 8px 36px; margin-top: 0; }.operation-note li { padding: 0 0 12px 3px; font-size: 13px; line-height: 1.8; color: var(--el-text-color-regular); }
@media (max-width: 1200px) { .workbench-body { grid-template-columns: minmax(0, 1fr); }.workbench-aside { grid-template-columns: 1fr 1fr; }.metric-grid { gap: 12px; }.metric { padding: 16px; } }
@media (max-width: 700px) { .shop-workbench { padding: 18px 12px; }.workbench-heading { align-items: flex-start; flex-direction: column; }h1 { font-size: 21px; }.metric-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }.metric strong { font-size: 28px; }.workbench-aside { grid-template-columns: 1fr; }.refresh-area { width: 100%; justify-content: space-between; }.panel-heading { padding: 16px; } }
</style>
