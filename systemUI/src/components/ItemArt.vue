<script setup>
import { computed, ref, watch } from 'vue'
import { mediaUrl } from '../utils/format.js'
import Icon from './Icon.vue'
const props = defineProps({ src: String, alt: { type: String, default: '' } })
const failed = ref(false)
watch(() => props.src, () => { failed.value = false })
const safe = computed(() => mediaUrl(props.src))
const tile = computed(() => /^\/images\/item-atlas\.png#[0-5]$/.test(safe.value) ? Number(safe.value.split('#')[1]) : null)
const tileStyle = computed(() => tile.value === null ? {} : { backgroundImage: 'url(/images/item-atlas.png)', backgroundPosition: `${tile.value % 3 * 50}% ${Math.floor(tile.value / 3) * 100}%` })
</script>
<template>
  <div class="item-art" :class="{ 'is-tile': tile !== null }" :style="tileStyle" :role="tile !== null ? 'img' : undefined" :aria-label="tile !== null ? alt : undefined">
    <img v-if="safe && tile === null && !failed" :src="safe" :alt="alt" loading="lazy" @error="failed = true" />
    <div v-else-if="!safe || failed" class="art-fallback"><Icon name="box" :size="42" /><span>暂无图片</span></div>
  </div>
</template>
