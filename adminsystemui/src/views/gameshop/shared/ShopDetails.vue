<template>
  <el-drawer v-model="visible" :title="`${config.title}详情`" size="min(880px, 96vw)">
    <div v-loading="loading">
      <el-alert v-if="error" :title="error" type="error" :closable="false" />
      <template v-if="data">
        <el-descriptions :column="2" border><el-descriptions-item v-for="entry in fields" :key="entry.key" :label="entry.label">{{ display(resource,entry.key,data[entry.key]) }}</el-descriptions-item></el-descriptions>
        <template v-if="resource === 'props'"><h3>商品图片</h3><el-image v-for="image in data.images" :key="image.url" :src="image.url" class="detail-image" :preview-src-list="data.images.map(i=>i.url)" preview-teleported /><h3>展示规格</h3><el-descriptions border><el-descriptions-item v-for="spec in data.specs" :key="spec.name" :label="spec.name">{{ spec.value }}</el-descriptions-item></el-descriptions><h3>商品详情</h3><p class="plain-detail">{{ plainText(data.detailHtml) }}</p></template>
        <template v-if="resource === 'orders'">
          <h3>商品明细</h3><el-table :data="data.items" border><el-table-column prop="propName" label="商品" /><el-table-column prop="unitPrice" label="单价" /><el-table-column prop="quantity" label="数量" width="75" /><el-table-column prop="subtotal" label="小计" /></el-table>
          <h3>交付资料</h3><el-descriptions :column="1" border><el-descriptions-item v-for="(label,key) in deliveryLabels" :key="key" :label="label">{{ key==='serverName' && data.deliveryInfo?.servers?.length ? data.deliveryInfo.servers.map(server=>`${server.categoryName}：${server.serverName}`).join('；') : data.deliveryInfo?.[key] || '—' }}</el-descriptions-item><el-descriptions-item label="买家备注">{{ data.remark || '—' }}</el-descriptions-item><el-descriptions-item label="交付说明">{{ data.delivery?.note || '尚未交付' }}</el-descriptions-item><el-descriptions-item label="取消原因">{{ data.cancelReason || '—' }}</el-descriptions-item><el-descriptions-item label="支付编号">{{ data.payment?.paymentNo || '—' }}</el-descriptions-item></el-descriptions>
          <h3>状态记录</h3><el-timeline><el-timeline-item v-for="(log,index) in data.logs" :key="index" :timestamp="display(resource,'createdAt',log.createdAt)">{{ log.reason }} · {{ orderStates[log.toStatus] }}</el-timeline-item></el-timeline>
        </template>
        <template v-if="resource === 'reviews'"><h3>评价内容</h3><p class="plain-detail">{{ data.content }}</p><el-alert v-if="data.hideReason" :title="`隐藏原因：${data.hideReason}`" type="warning" :closable="false" /></template>
        <template v-if="resource === 'banners' || resource === 'categories'"><el-image v-if="data.imageUrl || data.iconUrl" :src="data.imageUrl || data.iconUrl" class="detail-image" /></template>
      </template>
    </div>
    <template #footer><el-button @click="visible=false">关闭</el-button></template>
  </el-drawer>
</template>
<script setup>
import { computed,ref } from 'vue'
import { getShop } from '@/api/gameshop'
import { configs,display,orderStates } from './config'
const props=defineProps({resource:{type:String,required:true}})
const config=computed(()=>configs[props.resource]), visible=ref(false),data=ref(null),loading=ref(false),error=ref('')
const fields=computed(()=>[{key:config.value.id,label:'编号'},...config.value.columns.map(([key,label])=>({key,label})),...(props.resource==='props'?[{key:'version',label:'数据版本'}]:[])])
const deliveryLabels={gameAccount:'游戏账号',serverName:'区服',roleName:'角色名'}
function plainText(html){const doc=new DOMParser().parseFromString(html || '', 'text/html');return doc.body.textContent || ''}
async function open(row){visible.value=true;loading.value=true;data.value=null;error.value='';try{data.value=props.resource==='stock-logs'?row:(await getShop(props.resource,row[config.value.id])).data}catch(e){error.value=e.response?.data?.msg || '详情加载失败，请关闭后重试'}finally{loading.value=false}}
defineExpose({open})
</script>
<style scoped>.detail-image{width:140px;height:110px;margin:12px 12px 12px 0}.plain-detail{line-height:1.8;white-space:pre-wrap;overflow-wrap:anywhere}h3{font-size:15px;margin:24px 0 14px}</style>
