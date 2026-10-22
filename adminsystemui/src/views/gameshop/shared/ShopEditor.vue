<template>
  <el-dialog v-model="visible" :title="`${editing ? '修改' : '新增'}${config.title}`" width="min(860px, 94vw)" :close-on-click-modal="false" @closed="reset">
    <el-form v-if="visible" ref="formRef" :model="form" :rules="rules" label-width="110px" :disabled="saving">
      <template v-if="resource === 'categories'">
        <el-form-item label="分类名称" prop="name"><el-input v-model="form.name" maxlength="30" show-word-limit /></el-form-item>
        <el-form-item label="分类图标"><el-image v-if="form.iconUrl" :src="form.iconUrl" class="small-image" /><ShopUploadButton @uploaded="file => form.iconUrl = file.url" /><el-button v-if="form.iconUrl" link @click="form.iconUrl = null">清除图标</el-button></el-form-item>
        <el-form-item label="热门推荐"><el-switch v-model="form.recommended" /></el-form-item>
      </template>
      <template v-if="resource === 'banners'">
        <el-form-item label="轮播标题" prop="title"><el-input v-model="form.title" maxlength="60" show-word-limit /></el-form-item>
        <el-form-item label="轮播图片" prop="imageUrl"><el-image v-if="form.imageUrl" :src="form.imageUrl" class="banner-image" /><ShopUploadButton @uploaded="file => form.imageUrl = file.url" /></el-form-item>
        <el-form-item label="目标商品" prop="targetPropId"><el-select v-model="form.targetPropId" filterable remote :remote-method="searchProducts" :loading="optionsLoading" style="width:100%" placeholder="输入商品名称搜索"><el-option v-for="p in products" :key="p.propId" :value="p.propId" :label="`${p.name}（${p.propId}）`" /></el-select></el-form-item>
      </template>
      <template v-if="resource === 'props'">
        <el-form-item label="商品名称" prop="name"><el-input v-model="form.name" maxlength="80" show-word-limit /></el-form-item>
        <el-form-item label="游戏分类" prop="categoryId"><el-select v-model="form.categoryId" filterable remote :remote-method="searchCategories" :loading="optionsLoading" style="width:100%" placeholder="输入分类名称搜索"><el-option v-for="c in categories" :key="c.categoryId" :value="c.categoryId" :label="`${c.name}${c.status === '0' ? '（停用）' : ''}`" /></el-select></el-form-item>
        <el-row :gutter="16"><el-col :span="12"><el-form-item label="销售价格" prop="price"><el-input v-model="form.price" placeholder="49.90"><template #prefix>¥</template></el-input></el-form-item></el-col><el-col :span="12"><el-form-item label="划线原价" prop="originalPrice"><el-input v-model="form.originalPrice" placeholder="可不填写"><template #prefix>¥</template></el-input></el-form-item></el-col></el-row>
        <el-form-item v-if="!editing" label="初始库存" prop="initialStock"><el-input-number v-model="form.initialStock" :min="0" :max="1000000000" :precision="0" /></el-form-item>
        <el-form-item v-else label="当前库存"><el-tag>{{ existingStock }}</el-tag><span class="form-hint">库存请通过列表中的“调整库存”操作修改。</span></el-form-item>
        <el-form-item label="商品图片" prop="images">
          <div class="image-grid"><div v-for="(image,index) in form.images" :key="image.url" class="image-item"><el-image :src="image.url" fit="cover" class="product-image" /><el-radio v-model="form.coverUrl" :value="image.url">设为封面</el-radio><el-button link type="danger" @click="removeImage(index)">移除</el-button></div></div>
          <ShopUploadButton v-if="form.images.length < 10" @uploaded="addImage" /><div class="form-hint">1–10 张图片，选择其中一张作为封面。</div>
        </el-form-item>
        <el-form-item label="展示规格"><div class="spec-list"><el-row v-for="(spec,index) in form.specs" :key="index" :gutter="8" class="spec-row"><el-col :span="9"><el-input v-model="spec.name" maxlength="30" placeholder="规格名称，如品质" /></el-col><el-col :span="12"><el-input v-model="spec.value" maxlength="100" placeholder="规格值，如史诗" /></el-col><el-col :span="3"><el-button link type="danger" @click="form.specs.splice(index,1)">移除</el-button></el-col></el-row><el-button v-if="form.specs.length < 20" icon="Plus" @click="form.specs.push({ name: '', value: '' })">添加规格</el-button></div></el-form-item>
        <el-form-item label="交付信息" prop="deliveryFields"><el-checkbox-group v-model="form.deliveryFields"><el-checkbox value="gameAccount">游戏账号</el-checkbox><el-checkbox value="serverName">区服</el-checkbox><el-checkbox value="roleName">角色名</el-checkbox></el-checkbox-group></el-form-item>
        <el-form-item label="商品详情" prop="detailHtml"><div class="detail-editor"><QuillEditor v-model:content="form.detailHtml" content-type="html" :toolbar="toolbar" theme="snow" /></div></el-form-item>
      </template>
      <el-form-item v-if="resource !== 'props'" label="显示排序"><el-input-number v-model="form.sort" :min="0" :max="9999" :precision="0" /></el-form-item>
      <el-form-item label="状态"><el-radio-group v-model="form.status"><el-radio value="0">{{ resource === 'props' ? '下架' : '停用' }}</el-radio><el-radio value="1">{{ resource === 'props' ? '上架' : '启用' }}</el-radio></el-radio-group></el-form-item>
    </el-form>
    <template #footer><el-button :disabled="saving" @click="visible=false">取消</el-button><el-button type="primary" :loading="saving" @click="save">保存</el-button></template>
  </el-dialog>
</template>
<script setup>
import { computed, reactive, ref, toRaw } from 'vue'
import { ElMessage } from 'element-plus'
import { QuillEditor } from '@vueup/vue-quill'
import '@vueup/vue-quill/dist/vue-quill.snow.css'
import ShopUploadButton from './ShopUploadButton.vue'
import { configs } from './config'
import { createShop, updateShop, getShop, listShop } from '@/api/gameshop'
const props = defineProps({ resource: { type: String, required: true } })
const emit = defineEmits(['saved'])
const config = computed(() => configs[props.resource])
const visible=ref(false), saving=ref(false), editing=ref(false), formRef=ref(), currentId=ref(), existingStock=ref(0), categories=ref([]), products=ref([]), optionsLoading=ref(false)
const form = reactive({})
const toolbar = [[{header:[2,3,false]}],['bold','italic','blockquote'],[{list:'ordered'},{list:'bullet'}],['link'],['clean']]
const priceRule={validator:(_rule,value,callback)=> !/^(0|[1-9][0-9]{0,9})\.[0-9]{2}$/.test(value || '') || value === '0.00' ? callback(new Error('请输入大于零的两位小数价格')) : callback(),trigger:'blur'}
const optionalPrice={validator:(_rule,value,callback)=> value && !/^(0|[1-9][0-9]{0,9})\.[0-9]{2}$/.test(value) ? callback(new Error('请输入两位小数价格')) : callback(),trigger:'blur'}
const rules={name:[{required:true,min:2,max:80,message:'名称至少2个字符',trigger:'blur'}],title:[{required:true,message:'请输入标题',trigger:'blur'}],categoryId:[{required:true,message:'请选择游戏分类',trigger:'change'}],targetPropId:[{required:true,message:'请选择目标商品',trigger:'change'}],price:[priceRule],originalPrice:[optionalPrice],imageUrl:[{required:true,message:'请上传轮播图片',trigger:'change'}],images:[{type:'array',required:true,min:1,max:10,message:'请上传1至10张商品图片',trigger:'change'}],deliveryFields:[{type:'array',required:true,min:1,message:'至少选择一项交付信息',trigger:'change'}]}
function reset(){Object.keys(form).forEach(key=>delete form[key]);formRef.value?.clearValidate()}
async function searchCategories(keyword=''){optionsLoading.value=true;try{categories.value=(await listShop('categories',{keyword,pageNum:1,pageSize:50})).rows}finally{optionsLoading.value=false}}
async function searchProducts(keyword=''){optionsLoading.value=true;try{products.value=(await listShop('props',{keyword,pageNum:1,pageSize:50})).rows}finally{optionsLoading.value=false}}
async function open(row){reset();editing.value=!!row;currentId.value=row?.[config.value.id];if(row){const data=(await getShop(props.resource,currentId.value)).data;const keys=props.resource==='categories'?['name','iconUrl','sort','recommended','status','version']:props.resource==='banners'?['title','imageUrl','targetPropId','sort','status','version']:['categoryId','name','coverUrl','price','originalPrice','images','detailHtml','specs','deliveryFields','status','version'];keys.forEach(key=>form[key]=structuredClone(data[key]));existingStock.value=data.stock;if(props.resource==='props')categories.value=[{categoryId:data.categoryId,name:data.categoryName,status:'1'}];if(props.resource==='banners')products.value=[{propId:data.targetPropId,name:`商品 ${data.targetPropId}`}]}else if(props.resource==='categories')Object.assign(form,{name:'',iconUrl:null,sort:0,recommended:false,status:'0'});else if(props.resource==='banners')Object.assign(form,{title:'',imageUrl:null,targetPropId:null,sort:0,status:'0'});else Object.assign(form,{categoryId:null,name:'',coverUrl:null,price:'',originalPrice:null,images:[],detailHtml:'',specs:[],deliveryFields:['roleName'],status:'0',initialStock:0});visible.value=true;if(props.resource==='props' && !row)await searchCategories();if(props.resource==='banners' && !row)await searchProducts()}
function addImage(file){if(form.images.some(i=>i.url===file.url))return;form.images.push({url:file.url,sort:form.images.length});if(!form.coverUrl)form.coverUrl=file.url}
function removeImage(index){const [image]=form.images.splice(index,1);form.images.forEach((i,n)=>i.sort=n);if(form.coverUrl===image.url)form.coverUrl=form.images[0]?.url || null}
async function save(){if(!await formRef.value.validate().catch(()=>false))return;if(props.resource==='props' && form.specs.some(s=>!s.name.trim() || !s.value.trim())){ElMessage.warning('请填写完整规格或移除空行');return}saving.value=true;try{const data=structuredClone(toRaw(form));if(data.originalPrice==='')data.originalPrice=null;const reply=editing.value?await updateShop(props.resource,currentId.value,data):await createShop(props.resource,data);visible.value=false;ElMessage.success('保存成功');emit('saved',reply.data)}catch(error){if(error.response?.data?.errorCode==='MALL_VERSION_CONFLICT'){visible.value=false;emit('saved')}}finally{saving.value=false}}
defineExpose({open})
</script>
<style scoped>
.small-image{width:56px;height:56px;margin-right:12px}.banner-image{width:210px;height:84px;margin-right:12px}.form-hint{font-size:12px;color:#7b8494;margin-left:10px}.image-grid{display:flex;flex-wrap:wrap;gap:12px;width:100%;margin-bottom:12px}.image-item{width:126px;display:flex;flex-direction:column;align-items:center;border:1px solid #e6eaf0;padding:8px;border-radius:6px}.product-image{width:106px;height:92px}.spec-list,.detail-editor{width:100%}.spec-row{margin-bottom:8px}.detail-editor :deep(.ql-container){min-height:160px;max-height:340px;overflow:auto}.detail-editor :deep(.ql-editor){min-height:160px}
</style>
