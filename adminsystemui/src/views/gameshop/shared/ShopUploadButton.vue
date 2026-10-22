<template>
  <el-upload v-hasPermi="['mall:media:upload']" :show-file-list="false" accept=".png,.jpg,.jpeg,.webp" :http-request="send" :before-upload="check" :disabled="busy">
    <el-button :loading="busy" icon="Upload">上传图片</el-button>
    <template #tip><div class="el-upload__tip">PNG、JPEG 或 WebP，不超过 5 MiB，宽高不超过 4096 像素。</div></template>
  </el-upload>
</template>
<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { uploadShopImage } from '@/api/gameshop'
const emit = defineEmits(['uploaded'])
const busy = ref(false)
function check(file) { if (!/\.(png|jpe?g|webp)$/i.test(file.name) || file.size > 5 * 1024 * 1024) { ElMessage.error('请选择 5 MiB 以内的 PNG、JPEG 或 WebP 图片'); return false } return true }
async function send(options) { busy.value = true; try { const reply = await uploadShopImage(options.file); emit('uploaded', reply.data); options.onSuccess(reply) } catch (error) { options.onError(error) } finally { busy.value = false } }
</script>
