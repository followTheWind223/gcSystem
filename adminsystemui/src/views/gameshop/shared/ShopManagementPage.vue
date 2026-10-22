<template>
  <div class="app-container shop-management">
    <div class="page-heading"><div><h2>{{ config.title }}</h2><p>{{ config.description }}</p></div><el-button icon="Refresh" :loading="loading" @click="load">刷新列表</el-button></div>
    <el-form :inline="true" :model="query" class="search-panel" @submit.prevent="search">
      <el-form-item v-if="['categories','props','banners','members'].includes(resource)" :label="resource==='members' ? '账号 / 昵称' : '关键词'"><el-input v-model="query.keyword" clearable placeholder="输入关键词" @keyup.enter="search" /></el-form-item>
      <el-form-item v-if="resource==='orders'" label="订单号"><el-input v-model="query.orderNo" clearable placeholder="完整订单号" @keyup.enter="search" /></el-form-item>
      <el-form-item v-if="['orders','reviews'].includes(resource)" label="会员ID"><el-input v-model="query.memberId" clearable placeholder="十进制ID" @keyup.enter="search" /></el-form-item>
      <el-form-item v-if="['reviews','stock-logs'].includes(resource)" label="商品ID"><el-input v-model="query.propId" clearable placeholder="十进制ID" @keyup.enter="search" /></el-form-item>
      <el-form-item v-if="states.length" label="状态"><el-select v-model="query.status" clearable placeholder="全部状态" style="width:140px"><el-option v-for="state in states" :key="state.value" :value="state.value" :label="state.label" /></el-select></el-form-item>
      <el-form-item v-if="resource==='stock-logs'" label="业务类型"><el-select v-model="query.bizType" clearable placeholder="全部业务" style="width:160px"><el-option v-for="(label,value) in inventoryTypes" :key="value" :value="value" :label="label" /></el-select></el-form-item>
      <el-form-item><el-button type="primary" icon="Search" @click="search">搜索</el-button><el-button icon="RefreshLeft" @click="reset">重置</el-button></el-form-item>
    </el-form>
    <div class="operation-bar" aria-label="操作区域">
      <el-button v-if="config.editable" v-hasPermi="[permission('add')]" type="primary" icon="Plus" @click="editor.open()">新增{{ config.title }}</el-button>
      <el-button v-hasPermi="[permission('query')]" icon="View" :disabled="selection.length!==1" @click="details.open(selection[0])">查看所选</el-button>
      <el-button v-if="config.editable" v-hasPermi="[permission('edit')]" type="success" plain icon="Edit" :disabled="selection.length!==1 || acting" @click="editor.open(selection[0])">修改所选</el-button>
      <el-button v-if="config.editable" v-hasPermi="[permission('remove')]" type="danger" plain icon="Delete" :disabled="selection.length!==1 || acting" @click="remove(selection[0])">删除所选</el-button>
      <el-button v-if="resource==='props'" v-hasPermi="['mall:stock:list']" icon="List" @click="router.push('/gameshop/stock-logs')">库存流水</el-button>
      <span class="selection-hint">{{ selection.length ? `已选择 ${selection.length} 条` : '选择一条记录可进行操作' }}</span>
    </div>
    <el-alert v-if="error" type="error" :title="error" :closable="false" show-icon class="error-alert" />
    <el-table ref="tableRef" v-loading="loading" :data="rows" row-key="_shopId" :empty-text="error ? '加载失败，请点击刷新重试' : '暂无数据'" @selection-change="selection=$event">
      <el-table-column type="selection" width="45" />
      <el-table-column v-if="['props','categories','banners'].includes(resource)" label="图片" :width="resource==='banners'?140:95" align="center">
        <template #default="{row}">
          <el-image v-if="row.coverUrl || row.iconUrl || row.imageUrl" :src="row.coverUrl || row.iconUrl || row.imageUrl" :alt="row.name || row.title" :preview-src-list="[row.coverUrl || row.iconUrl || row.imageUrl]" preview-teleported fit="cover" class="catalog-thumbnail" :class="{'banner-thumbnail':resource==='banners'}" @click.stop>
            <template #error><span class="image-state">加载失败</span></template>
          </el-image>
          <span v-else class="image-state">暂无图片</span>
        </template>
      </el-table-column>
      <el-table-column v-for="[key,label] in config.columns" :key="key" :prop="key" :label="label" :min-width="['orderNo','createdAt','updatedAt','lastLoginAt'].includes(key)?175:110" show-overflow-tooltip>
        <template #default="{row}"><el-tag v-if="key==='status'" :type="tagType(row.status)">{{ display(resource,key,row[key]) }}</el-tag><span v-else>{{ display(resource,key,row[key]) }}</span></template>
      </el-table-column>
      <el-table-column label="操作" fixed="right" :width="resource==='props'?310:resource==='orders'?260:resource==='categories'?330:220" align="center">
        <template #default="{row}">
          <el-button v-hasPermi="[permission('query')]" link type="primary" icon="View" @click="details.open(row)">查看</el-button>
          <el-button v-if="resource==='categories'" v-hasPermi="['mall:server:list']" link type="primary" @click="router.push({path:'/gameshop/game-servers',query:{categoryId:row.categoryId}})">管理区服</el-button>
          <el-button v-if="config.editable" v-hasPermi="[permission('edit')]" link type="primary" :disabled="acting" @click="editor.open(row)">修改</el-button>
          <el-button v-if="resource==='props'" v-hasPermi="['mall:prop:edit']" link type="warning" :disabled="acting" @click="toggleProp(row)">{{ row.status==='1' ? '下架' : '上架' }}</el-button>
          <el-button v-if="resource==='props'" v-hasPermi="['mall:prop:stock']" link type="success" :disabled="acting" @click="openStock(row)">调整库存</el-button>
          <el-button v-if="config.editable" v-hasPermi="[permission('remove')]" link type="danger" :disabled="acting" @click="remove(row)">删除</el-button>
          <el-button v-if="resource==='members'" v-hasPermi="['mall:member:edit']" link :type="row.status==='0'?'danger':'success'" :disabled="acting" @click="toggleMember(row)">{{ row.status==='0'?'禁用':'启用' }}</el-button>
          <el-button v-if="resource==='orders' && row.status==='1'" v-hasPermi="['mall:order:cancel']" link type="danger" :disabled="acting" @click="cancel(row)">取消订单</el-button>
          <el-button v-if="resource==='orders' && row.status==='2'" v-hasPermi="['mall:order:complete']" link type="success" :disabled="acting" @click="complete(row)">登记交付</el-button>
          <el-button v-if="resource==='reviews' && row.status==='VISIBLE'" v-hasPermi="['mall:review:remove']" link type="danger" :disabled="acting" @click="hide(row)">隐藏</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total>0" v-model:page="query.pageNum" v-model:limit="query.pageSize" :total="total" @pagination="load" />
    <ShopEditor v-if="config.editable" ref="editor" :resource="resource" @saved="load" />
    <ShopDetails ref="details" :resource="resource" />
    <el-dialog v-model="stockOpen" title="调整可售库存" width="480px" :close-on-click-modal="false">
      <p>{{ stockTarget?.name }} · 当前可售库存 {{ stockTarget?.stock }}</p>
      <el-form label-width="80px"><el-form-item label="增减数量"><el-input-number v-model="stock.delta" :min="-1000000" :max="1000000" :precision="0" /></el-form-item><el-form-item label="调整原因"><el-input v-model="stock.reason" type="textarea" maxlength="200" show-word-limit /></el-form-item></el-form>
      <el-alert type="info" :closable="false" title="正数补货，负数扣减；未确认成功时可按原内容重试。" />
      <template #footer><el-button :disabled="acting" @click="stockOpen=false">取消</el-button><el-button type="primary" :loading="acting" @click="submitStock">确认调整</el-button></template>
    </el-dialog>
  </div>
</template>
<script setup>
import { computed,onMounted,reactive,ref,watch } from 'vue'
import { useRoute,useRouter } from 'vue-router'
import { ElMessage,ElMessageBox } from 'element-plus'
import { configs,stateOptions,display,inventoryTypes } from './config'
import ShopEditor from './ShopEditor.vue'
import ShopDetails from './ShopDetails.vue'
import { listShop,deleteShop,setPropStatus,setMemberStatus,cancelOrder,deliverOrder,hideReview,adjustStock } from '@/api/gameshop'
const props=defineProps({resource:{type:String,required:true}}), router=useRouter(),route=useRoute()
const config=computed(()=>configs[props.resource]),states=computed(()=>stateOptions(props.resource))
const query=reactive({pageNum:1,pageSize:10}),rows=ref([]),total=ref(0),loading=ref(false),acting=ref(false),error=ref(''),selection=ref([]),tableRef=ref(),editor=ref(),details=ref()
const stockOpen=ref(false),stockTarget=ref(null),stock=reactive({requestKey:'',delta:1,reason:''})
function permission(action){return `mall:${config.value.permission}:${action==='query' && props.resource==='stock-logs'?'list':action}`}
function tagType(status){if(props.resource==='members')return status==='0'?'success':'danger';if(props.resource==='orders')return {'1':'warning','2':'primary','3':'info','4':'success'}[status];return ['1','VISIBLE'].includes(status)?'success':'info'}
async function load(){loading.value=true;error.value='';try{const params=Object.fromEntries(Object.entries(query).filter(([,value])=>value!=='' && value!=null));const reply=await listShop(props.resource,params);rows.value=reply.rows.map(row=>({...row,_shopId:row[config.value.id]}));total.value=reply.total;selection.value=[];tableRef.value?.clearSelection()}catch(e){error.value=e.response?.data?.msg || '列表加载失败，请重试'}finally{loading.value=false}}
function search(){query.pageNum=1;load()}
function reset(){Object.keys(query).forEach(key=>delete query[key]);Object.assign(query,{pageNum:1,pageSize:10});load()}
async function run(fn){if(acting.value)return;acting.value=true;try{await fn();ElMessage.success('操作成功');await load()}catch(e){if(!['cancel','close'].includes(e) && e.response?.status===409)await load()}finally{acting.value=false}}
async function reason(title,max=200){const {value}=await ElMessageBox.prompt('请填写原因或说明，至少2个字符。',title,{inputType:'textarea',inputValidator:value=>value?.trim().length>=2 && value.trim().length<=max || `请输入2至${max}个字符`,confirmButtonText:'确认',cancelButtonText:'取消'});return value.trim()}
function remove(row){run(async()=>{await ElMessageBox.confirm(`确认删除“${row.name || row.title}”？`,'删除确认',{type:'warning'});await deleteShop(props.resource,row[config.value.id])})}
function toggleProp(row){run(async()=>{await ElMessageBox.confirm(`确认${row.status==='1'?'下架':'上架'}“${row.name}”？`,'商品状态');await setPropStatus(row.propId,{status:row.status==='1'?'0':'1',version:row.version})})}
function toggleMember(row){run(async()=>{const note=await reason(`${row.status==='0'?'禁用':'启用'}会员 ${row.username}`);await setMemberStatus(row.memberId,{status:row.status==='0'?'1':'0',reason:note})})}
function cancel(row){run(async()=>{const note=await reason('取消待支付订单');await cancelOrder(row.orderId,{reason:note})})}
function complete(row){run(async()=>{const note=await reason('登记道具交付',1000);await deliverOrder(row.orderId,{deliveryNote:note})})}
function hide(row){run(async()=>{const note=await reason('隐藏违规评价');await hideReview(row.reviewId,{reason:note})})}
function openStock(row){stockTarget.value=row;Object.assign(stock,{requestKey:crypto.randomUUID(),delta:1,reason:''});stockOpen.value=true}
async function submitStock(){if(!stock.delta || stock.reason.trim().length<2){ElMessage.warning('请填写非零增减数量和至少2个字符的原因');return}await run(async()=>{await adjustStock(stockTarget.value.propId,{requestKey:stock.requestKey,delta:stock.delta,reason:stock.reason.trim()});stockOpen.value=false})}
function loadRouteFilters(){
  if(route.path!==`/gameshop/${props.resource}`)return
  const {status,orderNo}=route.query
  if(states.value.some(item=>item.value===status))query.status=status;else delete query.status
  if(props.resource==='orders'){
    if(typeof orderNo==='string' && orderNo.length<=40)query.orderNo=orderNo;else delete query.orderNo
  }
  query.pageNum=1;load()
}
watch(()=>route.fullPath,loadRouteFilters)
onMounted(loadRouteFilters)
</script>
<style scoped>
.catalog-thumbnail{width:60px;height:60px;border-radius:6px;vertical-align:middle;background:var(--el-fill-color-light)}.banner-thumbnail{width:110px}.image-state{font-size:12px;color:var(--el-text-color-secondary)}
.page-heading{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-bottom:22px}.page-heading h2{font-size:21px;margin:0 0 8px;font-weight:600;color:#253246}.page-heading p{font-size:13px;color:#788498;margin:0}.search-panel{padding:18px 18px 0;background:#f6f8fb;border:1px solid #e9edf3;border-radius:6px;margin-bottom:18px}.operation-bar{display:flex;align-items:center;flex-wrap:wrap;gap:8px;margin-bottom:16px;min-height:34px}.operation-bar :deep(.el-button+.el-button){margin-left:0}.selection-hint{font-size:12px;color:#8993a3;margin-left:auto}.error-alert{margin-bottom:16px}@media(max-width:700px){.page-heading{align-items:flex-start}.page-heading p{line-height:1.6}.selection-hint{width:100%;margin-left:0}.search-panel{padding:12px 12px 0}}
</style>
