<script setup>
import Icon from './Icon.vue'
defineProps({ loading: Boolean, error: Object, empty: Boolean, title: { type: String, default: '这里还没有内容' }, description: { type: String, default: '去商城发现你的下一件装备吧。' } })
defineEmits(['retry'])
</script>
<template>
  <div v-if="loading" class="state-panel" role="status"><span class="spinner" /><h3>正在加载…</h3><p>装备马上就绪</p></div>
  <div v-else-if="error" class="state-panel" role="alert"><span class="state-icon"><Icon name="info" :size="30" /></span><h3>{{ error.status === 404 ? '内容暂不可用' : '暂时无法加载' }}</h3><p>{{ error.message }}</p><button class="btn secondary" @click="$emit('retry')"><Icon name="refresh" :size="16" />重新加载</button></div>
  <div v-else-if="empty" class="state-panel"><span class="state-icon"><Icon name="box" :size="30" /></span><h3>{{ title }}</h3><p>{{ description }}</p><slot name="action"><RouterLink class="btn secondary" to="/props">探索道具<Icon name="arrow" :size="16" /></RouterLink></slot></div>
  <slot v-else />
</template>
