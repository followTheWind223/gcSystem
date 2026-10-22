<script setup>
import { ref, watch } from 'vue'
import { ElDialog, ElRate, ElMessage } from 'element-plus'
import { memberApi } from '../api/mall.js'
const props = defineProps({ item: Object })
const emit = defineEmits(['close', 'submitted'])
const score = ref(5), content = ref(''), error = ref(''), busy = ref(false), uncertain = ref(false)
watch(() => props.item, () => { score.value = 5; content.value = ''; error.value = ''; uncertain.value = false })
async function submit() {
  error.value = ''
  if (content.value.trim().length < 5) { error.value = '请写下至少 5 个字符的使用体验。'; return }
  busy.value = true
  try { await memberApi.review({ orderItemId: props.item.orderItemId, score: score.value, content: content.value.trim() }); ElMessage.success('评价已发布，感谢分享'); emit('submitted'); emit('close') }
  catch (e) { error.value = e.uncertain ? '评价结果尚未确认，请关闭窗口并在订单或我的评价中核对后再操作。' : e.message; if (e.uncertain || e.status === 409) { uncertain.value = true; emit('submitted') } }
  finally { busy.value = false }
}
</script>
<template><ElDialog :model-value="Boolean(item)" title="分享你的装备体验" width="min(520px, 94vw)" :close-on-click-modal="!busy" :close-on-press-escape="!busy" :show-close="!busy" @close="$emit('close')"><form @submit.prevent="submit"><p class="review-product-name">{{ item?.propName }}</p><label class="field">体验评分<ElRate v-model="score" :disabled="busy || uncertain" size="large" show-text /></label><label class="field">你的评价<textarea v-model="content" rows="5" minlength="5" maxlength="1000" :disabled="busy || uncertain" placeholder="道具是否符合预期？分享你的体验，给其他玩家一些参考。" required /><small class="muted text-right">{{ content.length }} / 1000</small></label><p v-if="error" class="form-error" role="alert">{{ error }}</p><div class="button-row"><button type="button" class="btn secondary" :disabled="busy" @click="$emit('close')">{{ uncertain ? '关闭并核对' : '稍后再写' }}</button><button class="btn" :disabled="busy || uncertain || !score">{{ busy ? '发布中…' : '发布评价' }}</button></div></form></ElDialog></template>
