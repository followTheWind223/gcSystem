<script setup>
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElPagination } from 'element-plus'
import { catalogApi } from '../api/mall.js'
import { cents } from '../utils/format.js'
import { useRequest } from '../composables/useRequest.js'
import Icon from '../components/Icon.vue'
import ProductCard from '../components/ProductCard.vue'
import StatePanel from '../components/StatePanel.vue'
import ShopSelect from '../components/ShopSelect.vue'
const route = useRoute(), router = useRouter(), categories = ref([]), categoryError = ref(null), minPrice = ref(''), maxPrice = ref(''), filterError = ref(''), searchText = ref('')
const sorts = [{ value: 'sales_desc', label: '人气优先' }, { value: 'on_sale_desc', label: '最新上架' }, { value: 'price_asc', label: '价格从低到高' }, { value: 'price_desc', label: '价格从高到低' }]
const params = computed(() => ({ pageNum: Math.min(100000, Math.max(1, Math.trunc(Number(route.query.pageNum)) || 1)), pageSize: 12, sort: sorts.some(({ value }) => value === route.query.sort) ? route.query.sort : 'sales_desc', ...(typeof route.query.keyword === 'string' ? { keyword: route.query.keyword.slice(0, 100) } : {}), ...(/^[1-9]\d{0,18}$/.test(route.query.categoryId) ? { categoryId: route.query.categoryId } : {}), ...(/^\d{1,10}\.\d{2}$/.test(route.query.minPrice) ? { minPrice: route.query.minPrice } : {}), ...(/^\d{1,10}\.\d{2}$/.test(route.query.maxPrice) ? { maxPrice: route.query.maxPrice } : {}) }))
const { data, error, loading, load } = useRequest(() => catalogApi.props(params.value))
function update(patch) { const query = { ...route.query, pageNum: undefined, ...patch }; for (const key in query) if (query[key] === undefined || query[key] === '') delete query[key]; router.push({ name: 'catalog', query }) }
function priceFilter() {
  filterError.value = ''
  const normalize = value => value === '' ? undefined : /^\d{1,10}(\.\d{1,2})?$/.test(value) ? `${value.split('.')[0]}.${(value.split('.')[1] || '').padEnd(2, '0')}` : null
  const min = normalize(minPrice.value), max = normalize(maxPrice.value)
  if (min === null || max === null || (min && max && cents(min) > cents(max))) { filterError.value = '请输入有效价格范围（最多两位小数）'; return }
  update({ minPrice: min, maxPrice: max })
}
async function loadCategories() { categoryError.value = null; try { categories.value = (await catalogApi.categories()).data } catch (e) { categoryError.value = e } }
watch(() => route.query, () => { minPrice.value = params.value.minPrice || ''; maxPrice.value = params.value.maxPrice || ''; searchText.value = params.value.keyword || ''; load() }, { immediate: true })
onMounted(() => { loadCategories(); window.addEventListener('mall-demo-change', load) }); onUnmounted(() => window.removeEventListener('mall-demo-change', load))
</script>
<template><div class="container page-view"><div class="page-heading"><span class="eyebrow">THE EQUIPMENT COLLECTION</span><h1>发现你的下一件装备<span class="heading-dot">.</span></h1><p>{{ params.keyword ? `“${params.keyword}” 的搜索结果` : '从稀有收藏到实用补给，为每一次冒险做好准备。' }}</p></div>
  <form class="catalog-mobile-search" role="search" @submit.prevent="update({ keyword: searchText.trim() })"><Icon name="search" :size="18" /><input v-model="searchText" maxlength="100" aria-label="搜索游戏或道具" placeholder="搜索游戏 / 道具" /><button class="btn small" type="submit">搜索</button></form>
  <section class="catalog-filters"><div class="filter-row"><span class="filter-label">游戏世界</span><div class="filter-chips"><button :class="{ selected: !params.categoryId }" @click="update({ categoryId: undefined })">全部游戏</button><button v-for="c in categories" :key="c.categoryId" :class="{ selected: params.categoryId === c.categoryId }" @click="update({ categoryId: c.categoryId })">{{ c.name }}</button><button v-if="categoryError" @click="loadCategories">分类加载失败，点击重试</button></div></div><div class="filter-row"><span class="filter-label">价格区间</span><form class="price-filter" @submit.prevent="priceFilter"><label><span>¥</span><input v-model="minPrice" inputmode="decimal" aria-label="最低价格" placeholder="最低价" maxlength="13" /></label><span>—</span><label><span>¥</span><input v-model="maxPrice" inputmode="decimal" aria-label="最高价格" placeholder="最高价" maxlength="13" /></label><button class="btn small secondary">确定</button><button type="button" class="text-button muted" @click="router.push('/props')">重置筛选</button></form><span v-if="filterError" class="field-error">{{ filterError }}</span></div></section>
  <div class="results-toolbar"><p>全部道具 <strong>{{ data?.total ?? '—' }}</strong><span v-if="params.keyword" class="search-chip">{{ params.keyword }}<button aria-label="清除搜索" @click="update({ keyword: undefined })"><Icon name="close" :size="14" /></button></span></p><div class="catalog-sort"><label for="catalog-sort">排序</label><ShopSelect id="catalog-sort" :model-value="params.sort" :options="sorts" label="商品排序" @update:model-value="update({ sort: $event })" /></div></div>
  <StatePanel :loading="loading" :error="error" :empty="data?.rows.length === 0" title="暂时没有匹配的道具" description="试试其他游戏，或调整搜索与价格区间。" @retry="load"><template #action><button class="btn secondary" @click="router.push('/props')">清除筛选</button></template><div class="product-grid catalog-products"><ProductCard v-for="(product, i) in data?.rows" :key="product.propId" :product="product" :index="i" /></div></StatePanel>
  <ElPagination v-if="data?.total > 12" background layout="prev, pager, next" :total="data.total" :page-size="12" :current-page="params.pageNum" @current-change="update({ pageNum: String($event) })" />
</div></template>
