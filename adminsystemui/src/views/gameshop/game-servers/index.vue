<template>
  <div class="app-container server-management">
    <header class="heading"><div><h2>游戏区服</h2><p>按游戏维护可交付区服，停用后不再接受新订单，历史交付信息保留。</p></div><el-button icon="Refresh" :loading="loading" @click="load">刷新列表</el-button></header>
    <el-form :inline="true" :model="query" class="search-panel" @submit.prevent="search">
      <el-form-item label="所属游戏"><el-select v-model="query.categoryId" filterable remote clearable :remote-method="loadCategories" :loading="categoriesLoading" placeholder="全部游戏" style="width:210px"><el-option v-for="item in categories" :key="item.categoryId" :label="item.name" :value="item.categoryId" /></el-select></el-form-item>
      <el-form-item label="区服名称"><el-input v-model="query.keyword" clearable maxlength="50" placeholder="输入区服名称" @keyup.enter="search" /></el-form-item>
      <el-form-item label="状态"><el-select v-model="query.status" clearable placeholder="全部状态" style="width:130px"><el-option label="启用" value="1" /><el-option label="停用" value="0" /></el-select></el-form-item>
      <el-form-item><el-button type="primary" icon="Search" @click="search">搜索</el-button><el-button icon="RefreshLeft" @click="resetSearch">重置</el-button></el-form-item>
    </el-form>
    <div class="operation-bar" aria-label="操作区域"><el-button v-hasPermi="['mall:server:add']" type="primary" icon="Plus" @click="open()">新增区服</el-button></div>
    <el-alert v-if="error" :title="error" type="error" show-icon :closable="false" class="error-alert" />
    <el-alert v-if="categoryError" :title="categoryError" type="warning" show-icon :closable="false" class="error-alert"><el-button link @click="loadCategories()">重新加载游戏</el-button></el-alert>
    <el-table v-loading="loading" :data="rows" row-key="serverId" :empty-text="error?'加载失败，请刷新重试':'暂无区服，请先新增'">
      <el-table-column prop="categoryName" label="所属游戏" min-width="150" show-overflow-tooltip />
      <el-table-column prop="name" label="区服名称" min-width="160" show-overflow-tooltip />
      <el-table-column prop="sort" label="排序" width="85" />
      <el-table-column label="状态" width="90"><template #default="{row}"><el-tag :type="row.status==='1'?'success':'info'">{{ row.status==='1'?'启用':'停用' }}</el-tag></template></el-table-column>
      <el-table-column prop="remark" label="备注" min-width="180" show-overflow-tooltip />
      <el-table-column label="更新时间" min-width="175"><template #default="{row}">{{ row.updatedAt?.replace('T',' ').replace('+08:00','') }}</template></el-table-column>
      <el-table-column label="操作" fixed="right" width="240" align="center"><template #default="{row}">
        <el-button v-hasPermi="['mall:server:edit']" link type="primary" :disabled="acting" @click="open(row)">修改</el-button>
        <el-button v-hasPermi="['mall:server:edit']" link :type="row.status==='1'?'warning':'success'" :disabled="acting" @click="toggle(row)">{{ row.status==='1'?'停用':'启用' }}</el-button>
        <el-button v-hasPermi="['mall:server:remove']" link type="danger" :disabled="acting" @click="remove(row)">删除</el-button>
      </template></el-table-column>
    </el-table>
    <pagination v-show="total>0" v-model:page="query.pageNum" v-model:limit="query.pageSize" :total="total" @pagination="load" />
    <el-dialog v-model="editorOpen" :title="editing?'修改区服':'新增区服'" width="min(560px,94vw)" :close-on-click-modal="false">
      <el-alert v-if="saveError" :title="saveError" type="error" :closable="false" class="error-alert" />
      <el-form ref="formRef" :model="form" :rules="rules" label-width="88px">
        <el-form-item label="所属游戏" prop="categoryId"><el-select v-model="form.categoryId" filterable remote :remote-method="loadCategories" :loading="categoriesLoading" :disabled="editing" placeholder="请选择游戏" style="width:100%"><el-option v-for="item in categories" :key="item.categoryId" :label="item.name" :value="item.categoryId" /></el-select></el-form-item>
        <el-form-item label="区服名称" prop="name"><el-input v-model="form.name" maxlength="50" show-word-limit placeholder="例如：一区、华东一区" /></el-form-item>
        <el-form-item label="显示排序" prop="sort"><el-input-number v-model="form.sort" :min="0" :max="9999" :precision="0" /></el-form-item>
        <el-form-item label="状态" prop="status"><el-radio-group v-model="form.status"><el-radio value="1">启用</el-radio><el-radio value="0">停用</el-radio></el-radio-group></el-form-item>
        <el-form-item label="备注"><el-input v-model="form.remark" type="textarea" maxlength="200" show-word-limit placeholder="可选，仅供后台管理查看" /></el-form-item>
      </el-form>
      <template #footer><el-button :disabled="acting" @click="editorOpen=false">取消</el-button><el-button type="primary" :loading="acting" @click="save">保存</el-button></template>
    </el-dialog>
  </div>
</template>
<script setup name="GameshopGameServers">
import { onMounted,reactive,ref,watch,nextTick } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage,ElMessageBox } from 'element-plus'
import { listShop,getShop,createShop,updateShop,deleteShop } from '@/api/gameshop'
const route=useRoute(), query=reactive({pageNum:1,pageSize:10}),rows=ref([]),total=ref(0),loading=ref(false),acting=ref(false),error=ref('')
const categories=ref([]),categoriesLoading=ref(false),categoryError=ref(''),form=reactive({}),formRef=ref(),editorOpen=ref(false),editing=ref(false),currentId=ref(null),saveError=ref('')
const rules={categoryId:[{required:true,message:'请选择所属游戏',trigger:'change'}],name:[{required:true,message:'请输入区服名称',trigger:'blur'},{validator:(_,value,callback)=>value?.trim()?callback():callback(new Error('区服名称不能为空白')),trigger:'blur'}],sort:[{required:true,message:'请输入排序',trigger:'change'}],status:[{required:true,message:'请选择状态',trigger:'change'}]}
async function load(){loading.value=true;error.value='';try{const params=Object.fromEntries(Object.entries(query).filter(([,value])=>value!=='' && value!=null));const r=await listShop('game-servers',params);rows.value=r.rows;total.value=r.total}catch(e){rows.value=[];total.value=0;error.value=e.response?.data?.msg || '区服加载失败，请重试'}finally{loading.value=false}}
async function loadCategories(keyword=''){categoriesLoading.value=true;categoryError.value='';try{const r=await listShop('categories',{keyword,pageNum:1,pageSize:50});categories.value=r.rows}catch(e){categoryError.value='游戏列表加载失败，请重新加载后再新增区服'}finally{categoriesLoading.value=false}}
function search(){query.pageNum=1;load()}
function resetSearch(){Object.keys(query).forEach(key=>delete query[key]);Object.assign(query,{pageNum:1,pageSize:10});load()}
function payload(row,status=row.status){return {categoryId:row.categoryId,name:row.name.trim(),sort:row.sort,status,remark:row.remark?.trim() || null,...(row.version!=null?{version:row.version}:{})}}
async function open(row){saveError.value='';editing.value=!!row;currentId.value=row?.serverId;Object.keys(form).forEach(key=>delete form[key]);if(row){try{const current=(await getShop('game-servers',row.serverId)).data;Object.assign(form,payload(current));if(!categories.value.some(c=>c.categoryId===current.categoryId))categories.value.push({categoryId:current.categoryId,name:current.categoryName})}catch(e){return}}else Object.assign(form,{categoryId:query.categoryId || null,name:'',sort:0,status:'1',remark:null});editorOpen.value=true;await nextTick();formRef.value?.clearValidate()}
async function save(){if(acting.value || !await formRef.value.validate().catch(()=>false))return;acting.value=true;saveError.value='';try{const body=payload(form);if(editing.value)await updateShop('game-servers',currentId.value,body);else await createShop('game-servers',body);editorOpen.value=false;ElMessage.success('区服已保存');await load()}catch(e){saveError.value=e.response?.data?.msg || '保存失败，请重试';if(e.response?.status===409)await load()}finally{acting.value=false}}
async function run(action){if(acting.value)return;acting.value=true;try{await action();ElMessage.success('操作成功');await load()}catch(e){if(e.response?.status===409)await load()}finally{acting.value=false}}
function toggle(row){run(async()=>{await ElMessageBox.confirm(`确认${row.status==='1'?'停用':'启用'} ${row.categoryName} / ${row.name}？`,'区服状态',{type:'warning'});await updateShop('game-servers',row.serverId,payload(row,row.status==='1'?'0':'1'))})}
function remove(row){run(async()=>{await ElMessageBox.confirm(`确认删除 ${row.categoryName} / ${row.name}？已有订单的区服快照会保留。`,'删除区服',{type:'warning'});await deleteShop('game-servers',row.serverId)})}
function loadRoute(){if(route.path!=='/gameshop/game-servers')return;const categoryId=route.query.categoryId;if(typeof categoryId==='string' && /^[1-9]\d{0,18}$/.test(categoryId))query.categoryId=categoryId;else delete query.categoryId;search()}
watch(()=>route.fullPath,loadRoute)
onMounted(()=>{loadRoute();loadCategories()})
</script>
<style scoped>
.heading{display:flex;justify-content:space-between;align-items:center;gap:16px;margin-bottom:22px}.heading h2{margin:0 0 8px;font-size:21px}.heading p{margin:0;font-size:13px;color:var(--el-text-color-secondary);line-height:1.7}.search-panel{padding:18px 18px 0;background:var(--el-fill-color-light);border:1px solid var(--el-border-color-lighter);border-radius:6px;margin-bottom:18px}.operation-bar{margin-bottom:16px}.error-alert{margin-bottom:16px}@media(max-width:700px){.heading{align-items:flex-start}.search-panel{padding:12px 12px 0}}
</style>
