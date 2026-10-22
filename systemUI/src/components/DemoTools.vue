<script setup>
import { ref } from 'vue'
import { scenarios, setScenario } from '../mock/adapter.js'
import Icon from './Icon.vue'
const open = ref(false), selected = ref('normal')
function change() { setScenario(selected.value); window.dispatchEvent(new Event('mall-demo-change')) }
</script>
<template><div class="demo-tools"><button class="demo-badge" @click="open = !open"><span class="status-dot" />演示模式<Icon name="tune" :size="13" /></button><div v-if="open" class="demo-popover"><strong>演示数据 · 仅当前页面会话</strong><p>刷新后重置，不写入真实商城。</p><label>测试场景<select v-model="selected" @change="change"><option v-for="[value, label] in scenarios" :key="value" :value="value">{{ label }}</option></select></label><p>登录：demo_member<br />密码：Example123!<br />图形码：7 · 邮箱码：123456</p><button class="text-button" @click="open = false">收起</button></div></div></template>
